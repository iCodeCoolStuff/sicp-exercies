(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (display next)
      (newline)
      (if (close-enough? guess next)
	next
	(try next))))
  (try first-guess))


(define (test)
  (fixed-point (lambda (x) (/ (log 1000.0) (log x))) 2)
)

; Test with average damping

(define (avg-damp f x)
  (/ (+ (f x) (/ x (f x))) 2)
)

(define (test2)
  (fixed-point (lambda (x) (average x (/ (log 1000) (log x)))) 2)
)

(define (average x y)
  (/ (+ x y) 2)
)

; Average damping significantly decreases the number of operations required to bring f(x)=x 
