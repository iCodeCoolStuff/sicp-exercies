(define (p) (p))
(define (test x y)
  (if (= x 0) 0 y))

; Prediction: The program will run in an infinite loop under applicative order evaluation because it will try to evaluate p before it runs the other arguments. 

; In normal-order evaluation, the program will evaluate the if statement first and return 0.
