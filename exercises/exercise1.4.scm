(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

; Prediction: The interpreter will evaluate the if statement first and return a plus the absolute value of b

(define (test)
  (display (a-plus-abs-b 2 3))
  (newline)
  (a-plus-abs-b 2 -3))
