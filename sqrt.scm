(define (average x y)
  (/ (+ x y ) 2)
)

(define (improve guess x)
  (average guess (/ x guess))
)

(define (good-enough? guess last-guess)
  (< (abs (/ (- last-guess guess) guess)) 0.001)
)

(define (sqrt-iter guess last-guess x)
  (if (good-enough? guess last-guess)
    guess
    (sqrt-iter (improve guess x) guess x))
)
