(define (for-each f l)
  (cond ((null? (cdr l)) (f (car l)))
	(else (f (car l)) (for-each f (cdr l)))))
