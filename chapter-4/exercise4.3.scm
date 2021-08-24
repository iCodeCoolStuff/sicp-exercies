(define op-table  (make-table))

(define (get key) ((op-table 'get) key))
(define (put key value) ((op-table 'put) key value))

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
	((variable? exp) (lookup-variable-value exp env))
	((get 'eval (car exp)) 
	 ((get 'eval (operator exp)) (operands exp)))
	((application? exp)
	 (apply (eval (operator exp) env)
		(list-of-values (operands exp) env)))
	(else
	  (error "Unknown expression type: EVAL" exp))))
