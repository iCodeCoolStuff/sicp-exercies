(define (and-exps exp) (cdr exp))
(define (or-exps exp) (cdr exp))

(define (eval-and exp)
  (define (and-rec exps)
    (cond ((null? exps) true)
	  ((not (eval (car exps))) false)
	  (else (and-rec (cdr exps)))))
  (and-rec (and-exps exp)))
	   
(define (eval-or exp)
  (define (or-rec exps)
    (cond ((null? exps) false)
	  ((eval (car exps)) true)
	  (else (or-rec (cdr exps)))))
  (or-rec (or-exps exp)))

(put 'and eval-and)
(put 'or eval-or)

; Derived expressions

(define (expand-and clauses)
  (if (null? clauses)
      true
      (let ((first (car clauses))
	    (rest (cdr clauses)))
	(make-if first
		 (expand-and rest)
		 false))))

(define (expand-or clauses)
  (if (null? clauses)
      false
      (let ((first (car clauses))
	    (rest (cdr clausees)))
	(make-if first
		 true
		 (expand-or rest)))))

(define (eval-and exp) (expand-and (and-exps exp)))
(define (eval-or exp) (expand-or (or-exps exp)))
