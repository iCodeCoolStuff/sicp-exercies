(define (instantiate exp frame unbound-var-handler)
  (define (copy exp)
    (cond ((var? exp)
           (let ((binding (binding-in-frame exp frame)))
             (if binding
                 (copy (binding-value binding))
                 (unbound-var-handler exp frame))))
          ((promise? exp) exp)
          ((pair? exp)
           (cons (copy (car exp)) (copy (cdr exp))))
          (else exp)))
  (copy exp))
 
(define (create-promise call)
  (list '*promise* call))

(define (promise? x)
  (and (pair? x) (eq? (car x) '*promise*)))

(define (promise-call promise)
  (cadr promise))

(define return-var (lambda (v f) v))

(define (any-vars? args)
  (not (null? (filter var? args))))

(define (add-promises vars frame call)
  (if (null? vars)
      frame
      (extend (car vars) (create-promise call) (add-promises (cdr vars) frame call))))

(define (lisp-value call frame-stream)
  (stream-flatmap
   (lambda (frame)
     (if (execute
          (instantiate
           call
           frame
           (lambda (v f)
             (error "Unknown pat var -- LISP-VALUE" v))))
         (singleton-stream frame)
         the-empty-stream))
     (let ((proc (instantiate call frame return-var)))
       (cond ((any-vars? (args proc))
              (singleton-stream (add-promises (filter var? (args proc)) frame call)))
             ((execute proc)
              (singleton-stream frame))
             (else the-empty-stream))))
   frame-stream))

(define (extend-if-consistent var dat frame)
  (let ((binding (binding-in-frame var frame)))
    (if binding
        (pattern-match (binding-value binding) dat frame)
        (if (promise? (binding-value binding))
            (fulfill-promise var dat (binding-value binding) (replace-in-frame var dat frame))
            (pattern-match (binding-value binding) dat frame))
        (extend var dat frame))))

 
(define (any-promises? args)
  (not (null? (filter promise? args))))

(define (replace-in-frame var val frame)
  (cond ((null? frame) '())
        ((equal? (binding-variable (car frame)) var)
         (extend (binding-variable (car frame)) val (cdr frame)))
        (else (cons (car frame) (replace-in-frame var val (cdr frame))))))

(define (fulfill-promise var val promise frame)
  (let ((new-call (instantiate (promise-call promise) (replace-in-frame var val frame) return-var)))
    (cond ((any-promises? (args new-call)) ; still promises needing to be fulfilled
           frame)
          ((execute new-call) ; ok
           frame)
          (else 'failed)))) ; new value did not pass the predicate test

(define (extend-if-possible var val frame)
  (let ((binding (binding-in-frame var frame)))
    (cond (binding
           (if (promise? val)
               (fulfill-promise var (binding-value binding) val frame)
               (unify-match
                (binding-value binding) val frame)))
          ((var? val)                     ; {\em ; ***}
           (let ((binding (binding-in-frame val frame)))
             (if binding
                 (if (promise? var)
                     (fulfill-promise val (binding-value binding) var frame)
                     (unify-match
                      var (binding-value binding) frame))
                 (extend var val frame))))
          ((depends-on? val var frame)    ; {\em ; ***}
           'failed)
