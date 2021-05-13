(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (test)
  (sqrt-iter-i 2000000000000.0 5000000000000))

; (sqrt-iter x 0.00000001)) 0.03125
; (sqrt 20000000000000000 50000000000000000) infinite recursion

(define (good-enough-better guess x)
  (< (abs (/ (- guess x) guess)) 0.001))

(define (sqrt-iter-i guess x)
  (if (good-enough-better guess (improve guess x))
      guess
      (sqrt-iter-i (improve guess x) x)))
