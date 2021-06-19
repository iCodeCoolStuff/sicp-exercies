; We have to modify the generic procedures for adding, subtracting, multiplying, and dividing complex numbers to use generic
; arithmetic functions.
; 
; We also have to add functions such as sine, cosine, sqrt, and arctangent. Complex selectors have to be modified to use these
; new generic functions.

(define (install-trig-package)
  (define (sine num)
    (sin (contents num)))

  (define (cosine num)
    (cos (contents num)))

  (define (arctan y x)
    (let ((y-contents (contents y))
	  (x-contents (contents x)))
      (atan y-contents x-contents)))

  (define (raise-to-real num)
    (if (eq? (type-tag num) 'real)
	num
	(raise num)))

  (put 'sine   'real sine)
  (put 'cosine 'real cosine)
  (put 'arctan 'real arctan)
  (put 'sine   'integer sine)
  (put 'cosine 'integer cosine)
  (put 'arctan 'integer arctan)
  (put 'sine   'rational (lambda (x) (sine (raise-to-real x))))
  (put 'cosine 'rational (lambda (x) (cosine (raise-to-real x))))
  (put 'arctan 'rational (lambda (y x) (arctan (raise-to-real y) (raise-to-real x))))
'done)

(define (install-math-package)
  (define (square-root num)
    (sqrt (contents num)))

  (define (square num)
    (apply-generic 'mul num num))

  (define (raise-to-real num)
    (if (eq? (type-tag num) 'real)
	num
	(raise num)))

  (put 'square-root 'integer square-root)
  (put 'square-root 'real    square-root)
  (put 'square-root 'rational (lambda (x) (square-root (raise-to-real x))))
  (put 'square      'integer  square)
  (put 'square      'real     square)
  (put 'square      'rational square)
'done)

(define (install-complex-package)
  (define (add-complex z1 z2)
    (make-from-real-imag (apply-generic 'add (real-part z1) (real-part z2))
			 (apply-generic 'add (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (apply-generic 'sub (real-part z1) (real-part z2))
			 (apply-generic 'sub (real-part z1) (real-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (apply-generic 'mul (magnitude z1) (magnitude z2))
		       (apply-generic 'add (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (apply-generic 'div (magnitude z1) (magnitude z2))
		       (apply-generic 'sub (angle z1) (angle z2))))
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex) 
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
'done)

(define (install-polar-package)
  (define (real-part z)
    (apply-generic 'mul (magnitude z) (apply-generic 'cosine (angle z))))
  (define (imag-part z)
    (apply-generic 'mul (magnitude z) (apply-generic 'sine (angle z))))
  (define (make-from-real-imag x y)
    (cons (apply-generic 'square-root (apply-generic 'add (apply-generic 'square x) (apply-generic 'square y)))
	  (apply-generic 'arctan y x)))

  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
'done)

(define (install-rectangular-package)
  (define (magnitude z)
    (apply-generic 'square-root (apply-generic 'add (apply-generic 'square (real-part z)) 
					            (apply-generic 'square (imag-part z)))))
  (define (angle z)
    (apply-generic 'arctan (imag-part z) (real-part z)))

  (define (make-from-mag-ang r a)
    (cons (apply-generic 'mul r (apply-generic 'cosine a)) (apply-generic 'mul r (apply-generic 'sine a))))

  (define (tag x) (attach-tag 'rectangular x))
  (put 'magnitude '(polar) magnitude)
  (put 'angle     '(polar) angle)
  (put 'make-from-mag-ang '(polar) (lambda (r a) (tag (make-from-mag-ang r a))))
'done)
