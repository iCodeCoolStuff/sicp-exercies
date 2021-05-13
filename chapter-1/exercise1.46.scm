(define (iterative-improve good-enough? method)
  (define (rec x)
    (let ((next (method x)))
      (if (good-enough? x next) x (rec next))))
  (lambda (x) (rec x)))

(define tolerance 0.00001)
(define (close-enough? v1 v2)
  (< (abs (- v1 v2)) tolerance))

(define (fixed-point f)
  (iterative-improve close-enough? f))

(define (average x y)
  (/ (+ x y) 2))

(define (square-root x)
  ((fixed-point (lambda (y) (average y (/ x y)))) x))

(define (test)
  (square-root 5))
