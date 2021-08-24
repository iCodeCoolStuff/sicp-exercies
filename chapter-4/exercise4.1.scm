; Left to right
(define (list-of-values exps env)
  (if (no-operands? exp)
      '()
      (let ((r (eval (first-exp exps) env)))
	(cons r (eval-sequence (rest-exps exps) env)))))

; Right to left
(define (list-of-values exps env)
  (if (no-operands? exp)
      '()
      (let ((r-exps (eval-sequence (rest-exps exps) env)))
	(cons (eval (first-exp exps) env)))))
      
