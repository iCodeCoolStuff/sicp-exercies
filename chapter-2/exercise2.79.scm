(define (install-equ?-package)

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

  (define (reduce x)
          (/ (numer x) (denom x)))

  (define (flatten num)
    (if (rational? num)
        (reduce num)
        num))

  (define (equ? n1 n2)
    (cond ((not (or (complex? n1) (complex? n2))) (eq? (flatten n1) (flatten n2)))
  	((and (complex? n1) (not (complex? n2))) (and (eq? (real-part n1) n2) (= (imag-part n1) 0)))
  	((and (complex? n2) (not (complex? n1))) (and (eq? (real-part n2) n1) (= (imag-part n2) 0)))
  	((and (complex? n1) (complex? n2)) (and (= (car (sub-complex n1 n2)) 0) (= (cdr (sub-complex n1 n2)) 0)))
  	(else false)))

  (put 'equ? '(scheme-number scheme-number) equ?)
  'done)
