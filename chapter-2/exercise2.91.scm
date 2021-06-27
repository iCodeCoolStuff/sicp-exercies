(define (div-terms L1 L2)
  (if (empty-termlist? L1)
      (list (the-empty-termlist) (the-empty-termlist))
      (let ((t1 (first-term L1))
	    (t2 (first-term L2)))
	(if (> (order t2) (order t1))
	    (list (the-empty-termlist) L1)
	    (let ((new-c (div (coeff t1) (coeff t2)))
		  (new-o (- (order t1) (order t2))))
	      (let ((rest-of-result 
		      (div-terms (sub-terms L1 (mul-term-by-all-terms (make-term new-o new-c)  L2)) L2)))
		(let ((terms     (car rest-of-result))
		      (rem       (cdr rest-of-result)))
		  (list (adjoin-term (make-term new-o new-c) terms) rem))))))))

(define (div-poly p1 p2)
  (if (same-variable? p1 p2)
      (div-terms (term-list p1) (term-list p2))
      (error "Polys do not have the same variable -- DIV-POLY" p1 p2)))