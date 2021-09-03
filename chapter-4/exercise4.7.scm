(define (let*? exp) (tagged-list? exp 'let*))
(define (let*-clauses exp) (cadr exp))
(define (let*-body exp) (cddr exp))
(define (variable clause)
  (car clause))
(define (expression clause)
  (cadr clause))
(define (let*->nested-lets exp)
  (let* ((clauses (let*-clauses exp))
	 (first (car clauses))
	 (rest (cdr clauses)))
    (make-let (list first)
	      (expand-lets (let*-clauses exp) (let*-body exp)))))

(define (expand-lets clauses body)
  (if (null? clauses)
      body
      (list (make-let (list (car clauses))
		(expand-lets (cdr clauses) body)))))

(define (eval-let* exp env)
  (eval (let*->nested-lets exp) env))

; It is possible to write let* in terms of derived expressions.
