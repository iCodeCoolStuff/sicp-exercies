(define (let? exp) (tagged-list? exp 'let))
(define (let-exps exp) (cadr exp))
(define (let-variables exp) (map car (let-exps exp)))
(define (let-body exp) (caddr exp))

(define (let->combination exp)
  (list (make-lambda (let-variables exp) (let-body exp)) (let-exps exp))) 

(define (eval-let exp env)
  (eval (let->combination exp) env))
