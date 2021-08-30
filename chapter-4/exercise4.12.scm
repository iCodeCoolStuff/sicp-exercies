(define (lookup-variable-value var env)
  (traverse-environment-for var (lambda (b) (cadr b)) env))

(define (set-variable-value! var val env)
  (traverse-environment-for var (lambda (b) (set-car! (cdr b) val)) env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (scan-frame frame var (lambda (b) (set-car! (cdr b) val))
	                  (lambda ()  (add-binding-to-frame! var val frame)))))

(define (traverse-environment-for var success-proc env)
  (let ((frame (first-frame env)))
    (if (eq? env the-empty-environment)
	(error "Unbound variable" env)
	(scan-frame frame var success-proc 
		          (lambda () (traverse-environment-for var
							       success-proc
							       (enclosing-environment env)))))))
(define (scan-frame frame var on-success on-failure)
  (let ((binding (scan var (frame-variables frame)
		           (frame-values frame))))
    (if binding
	(on-success binding)
	(on-failure))))
(define (scan var vars vals)
  (cond  ((null? vars) false)
         ((eq? var (car vars)) (cons vars vals))
	 (else (scan var (cdr vars) (cdr vals)))))
