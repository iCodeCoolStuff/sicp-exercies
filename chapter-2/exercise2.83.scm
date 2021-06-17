(define (raise-integer i)
  (make-rational i 1))

(define (raise-rational r)
  (/ (numer r) (denom r)))

(define (raise-real r)
  (make-complex r 0))

(define (raise num)
  (let ((type (type-tag num)))
    (cond ((eq? type 'integer)  (raise-integer num))
          ((eq? type 'rational) (raise-rational num))
	  ((eq? type 'real)     (raise-real num))
	  (else num))))
