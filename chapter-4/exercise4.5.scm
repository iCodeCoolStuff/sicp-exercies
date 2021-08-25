(define (test-recipient-clause? clause)
  (if (pair? exp)
      (eq? (cadr exp) '=>)
      false))

(define (cond-test clause) (car clause))
(define (cond-recipient clause) (caddr clause))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
	    (rest (cdr clauses)))
	(cond ((cond-else-clause? first)
	       (if (null? rest)
		   (sequence->exp (cond-actions first))
		   (error "ELSE clause isn't last -- COND->IF"
		          clauses)))
	      ((test-recipient-clause? first)
	       (make-if (cond-test first)
			(sequence->exp (list (cond-recipient first) (cond-test first)))
			(expand-clauses rest)))
	      (else 
		(make-if (cond-predicate first)
		         (sequence->exp (cond-actions first))
		         (expand-clauses rest)))))))
