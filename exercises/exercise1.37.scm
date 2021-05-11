(define (cont-frac n d k)
  (define (cont-frac-rec i)
    (if (= i k) (/ (n i) (d i)) (/ (n i) (+ (d i) (cont-frac-rec (+ i 1)))))
  )
  (cont-frac-rec 1)
)

(define (test)
  (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 12)
)

; A) k must be 12 for cont-frac to be accurate to 4 decimal places

; B)


(define (cont-frac-iter n d k)
  (define (iter i result)
    (cond ((= i k) (iter (- i 1) (/ (n i) (d i))))
	  ((> i 0) (iter (- i 1) (/ (n i) (+ (d i) result))))
	  (else    result)
    )
  )
  (iter k 0)
)

(define (test2)
  (cont-frac-iter (lambda (i) 1.0) (lambda (i) 1.0) 12)
)


(define (negative x)
  (- x)
)
