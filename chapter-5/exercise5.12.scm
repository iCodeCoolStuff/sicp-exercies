; Add these to make-new-machine

      (define (sources register)
        (map
         (lambda (inst)
          (let ((exp (cddr (instruction-text inst))))
            (cond ((operation-exp? exp) exp)
                  (else (car exp)))))
         (filter
          (lambda (inst) (is-source? inst register))
          (dispatch 'get-instructions))))

      (define (dispatch message)
      ...
              ((eq? message 'get-instructions)    (sort (remove-duplicate-instructions the-instruction-sequence) alpha-order))
              ((eq? message 'get-entry-points)    (filter entry-point? (dispatch 'get-instructions)))
              ((eq? message 'get-saved-registers) (remove-duplicates (map (lambda (inst) (cadr (instruction-text inst))) 
                                                                          (filter stacked? (dispatch 'get-instructions)))))
              ((eq? message 'get-sources) sources)
              ((eq? message 'get-register-names) (map car register-table))
      dispatch)))
 
; Add these to regsim.scm
 
(define (is-source? inst name)
  (let ((op     (car (instruction-text inst)))
        (target (cadr (instruction-text inst))))
    (and (eq? op 'assign)
         (eq? target name))))

(define (entry-point? inst)
  (eq? (car (instruction-text inst)) 'goto))

(define (stacked? inst)
  (let ((op (car (instruction-text inst))))
    (or (eq? op 'restore)
        (eq? op 'save))))

(define (delete-inst inst lst)
  (cond ((null? lst) '())
        ((equal? (instruction-text inst) (instruction-text (car lst)))
         (delete-inst inst (cdr lst)))
        (else
         (cons (car lst) (delete-inst inst (cdr lst))))))

(define (remove-duplicates lst)
  (if (null? lst)
      '()
      (cons (car lst) (remove-duplicates (delete (car lst) (cdr lst))))))

(define (remove-duplicate-instructions lst)
  (if (null? lst)
      '()
       (cons (car lst) (remove-duplicate-instructions (delete-inst (car lst) (cdr lst))))))

(define (difference lst1 lst2)
  (cond ((null? lst1) '())
        ((member (car lst1) lst2)
         (difference (cdr lst1) lst2))
        (else
         (cons (car lst1) (difference (cdr lst1) lst2)))))

(define (sort lst pred)
  (if (null? lst)
      '()
      (let* ((tops    (filter (lambda (e) (pred e (car lst))) (cdr lst)))
             (bottoms (difference (cdr lst) tops)))
        (append
         (sort tops pred)
         (list (car lst))
         (sort bottoms pred)))))

(define (alpha-order inst1 inst2)
  (symbol-list<? (instruction-text inst1)
                 (instruction-text inst2)))

(define (meh x)
  (or (symbol? x) (number? x)))

(define (cmp one two)
  (cond ((and (number? one) (number? two))
         (< one two))
        ((number? one) #f)
        ((number? two) #t)
        (else (symbol<? one two))))

(define (symbol-list<? lst1 lst2)
  (cond ((and (null? lst1) (null? lst2)) #f)
        ((null? lst1) #t)
        ((null? lst2) #f)
        ((and (meh (car lst1)) (meh (car lst2)))
         (if (eq? (car lst1) (car lst2))
             (symbol-list<? (cdr lst1) (cdr lst2)) ; nothing to see here
             (cmp (car lst1) (car lst2))))
        ((meh (car lst1)) #t)
        ((meh (car lst2)) #f)
        ((equal? (car lst1) (car lst2))
         (symbol-list<? (cdr lst1) (cdr lst2)))    ; nothing to see here either
        (else (symbol-list<? (car lst1) (car lst2)))))
