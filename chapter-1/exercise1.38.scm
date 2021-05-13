(define (cont-frac n d k)
  (define (cont-frac-rec i)
    (if (= i k) (/ (n i) (d i)) (/ (n i) (+ (d i) (cont-frac-rec (+ i 1)))))
  )
  (cont-frac-rec 1)
)


(define (e-2 n)
  (cont-frac (lambda (x) 1.0) d n)
)


(define (d x) 
  (cond ((= x 1) 1)
        ((= (remainder x 3) 2) (- x (floor (/ x 3))))
	(else 1)
  )
)

(define (test)
  (e-2 100)
)
