(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
	  (apply proc (map contents args))
	  (if (= (length args) 2)
	      (let ((type1 (car type-tags))
		    (type2 (cadr type-tags))
		    (a1 (car args))
		    (a2 (cadr args)))
		(cond ((eq? type1 type2)     (apply-generic op a1 a2))
		      ((higher? type1 type2) (apply-generic op a1 (raise a2)))
		      (else                  (apply-generic op (raise a1) a2))))
		(error "No method for these types"
		       (list op type-tags)))))))

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

(define (tmap type)
  (cond ((eq? type 'integer) 0)
     ((eq? type 'rational)   1)
     ((eq? type 'real)       2)
     ((eq? type 'complex)    3)
     (else                   4)))

(define (higher? type1 type2)
  (let ((ord1 (tmap type1))
	(ord2 (tmap type2)))
    (if (> ord2 ord1)
	true
	false)))
