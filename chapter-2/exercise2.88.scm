(define (sub-polynomials p1 p2)
  (cond ((=zero? p1) (negate p2))
        ((=zero? p2) p1)
	(else (add-poly p1 (negate p2)))))

(define (install-negate)
  (define (negate-polynomial polynomial)
    (make-polynomial (variable polynomial) (map negate (term-list polynomial))))

  (define (negate-term term)
    (make-term (order term) (mul (coeff term) -1)))

  (put 'negate 'term       negate-term)
  (put 'negate 'polynomial negate-polynomial)
'done)
