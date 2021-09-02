(define (let? exp) (tagged-list? exp 'let))
(define (let-bindings exp) (cadr exp))
(define (let-variables exp) (map car (let-bindings exp)))
(define (let-exps      exp) (map cadr (let-bindings exp)))
(define (let-body exp) (cddr exp))
(define (let->combination exp)
  (cons (make-lambda (let-variables exp) 
		     (let-body exp)) (let-exps exp)))

(define (eval-let exp env)
  (eval (let->combination exp) env))

(put 'let eval-let)
