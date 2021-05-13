(define (average x y) (/ (+ x y) 2))
(define (average-damp f)
  (lambda (x) (average x (f x))))

(define (compose f g)
  (lambda (x) (f (g x))))
(define (repeated f n)
  (define (rec i)
    (if (= i 1) (lambda (x) (f x)) (compose f (rec (- i 1)))))
  (rec n))

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
        next
	  (try next))))
  (try first-guess))

(define (nth-root x n)
  (fixed-point ((repeated average-damp (floor (/ (log n) (log 2)))) (lambda (y) (/ x (expt y (- n 1))))) 1.0))

(define (test)
  (nth-root 50000 12))
