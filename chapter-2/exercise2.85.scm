(define (install-project-package)
  (define (project num)
    (let ((type (type-tag num)))
      (cond ((eq? type 'complex)  (project-complex  num))
            ((eq? type 'real   )  (project-real     num))
            ((eq? type 'rational) (project-rational num))
	    (else num))))

  (define (project-complex num)
    (real-part num))
  
  (define (project-real num)
    (round num))

  (define (project-rational num)
    (let ((gcf (gcd (numer num) (denom num))))
      (/ (numer num) gcf)))

  (put 'project 'integer  project)
  (put 'project 'rational project)
  (put 'project 'real     project)
  (put 'project 'complex  project)
'done)

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

; ------------------------------------------------------------------------------------------

(define (equality-int? int1 int2)
  (= int1 int2))

(define (equality-rat? rat1 rat2)
  (let ((gcf1 (gcd (numer rat1) (denom rat1)))
	(gcf2 (gcd (numer rat2) (denom rat2))))
    (and (= (/ (numer rat1) gcf1) (/ (numer rat2) gcf2))
         (= (/ (denom rat1) gcf1) (/ (denom rat2) gcf2)))))

(define (equality-real? real1 real2)
  (= real1 real2))

(define (equality-complex? complex1 complex2)
  (and (= (real-part complex1) (real-part complex2))
       (= (imag-part complex1) (imag-part complex2))))


(define (apply-equality type)
  (cond ((eq? type 'integer) equality-int?)
        ((eq? type 'rational) equality-rat?)
	((eq? type 'real)     equality-real?)
	(else equality-complex?)))

(define (equality? num1 num2)
  (let ((type1 (type-tag num1))
	(type2 (type-tag num2)))
    (cond ((eq? type1 type2) ((apply-equality type1) num1 num2))
          ((higher? type1 type2) (equality? num1 (raise num2)))
	  (else (equality? (raise num1) num2)))))

; ------------------------------------------------------------------------------------------

(define (drop num)
  (let ((type (type-tag num)))
    (cond ((eq? type 'integer) num)
          ((equality? num (raise (project num))) (drop (project num)))
	  (else num))))

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
		(cond ((eq? type1 type2)     (drop (apply-generic op a1 a2)))
		      ((higher? type1 type2) (drop (apply-generic op a1 (raise a2))))
		      (else                  (drop (apply-generic op (raise a1) a2)))))
		(error "No method for these types"
		       (list op type-tags)))))))
