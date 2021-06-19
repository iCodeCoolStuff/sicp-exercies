(define (term-list sparse-polynomial)
  (define (term-iter ord poly result)
    (if (null? poly)
	result
        (let ((t (car poly)))
	  (if (= (order t) ord)
	      (term-iter (- ord 1) (cdr poly) (cons (coeff t) result))
	      (term-iter (- ord 1) poly  (cons 0 result))))))
  (term-iter (order (car sparse-polynomial)) sparse-polynomial ()))

(define (adjoin-term term term-list)
  (if (=zero? (coeff term))
      term-list
      (insert term term-list))) 

(define (insert term term-list)
  (let ((ord (- (length term-list) 1))
	(t (car term-list)))
    (if (= ord (order term))
	(cons (make-term ord (add (coeff t) (coeff term))) rest-terms)
	(append (list t) (insert term (rest-terms term-list))))))
