(define (install-=zero?-package)
  (define (type number)
    (cond ((eq? (type-tag number) 'scheme-number) 'scheme-number)
          ((eq? (type-tag number) 'complex      ) 'complex)
	  ((eq? (type-tag number) 'rational     ) 'rational)
	  (else (error "Bad tagged datum -- TYPE" number))))

  (define (complex? num)
    (if (eq? (type-tag num) 'complex)
        true
        false))

  (define (rational? num)
    (if (eq? (type-tag num) 'rational)
        true
        false))

  (define (=zero? arg)
    (cond ((eq? (type arg) 'scheme-number) (= arg 0))
          ((eq? (type arg) 'rational     ) (and (= (numer arg) 0) (not (= (denom arg) 0))))
	  ((eq? (type arg) 'complex      ) (and (= (real-part arg) 0) (= (imag-part arg) 0)))
	  (else (error "Bad tagged datum -- =ZERO?" arg))))
  (put '=zero? 'scheme-number =zero?)
  'done)
