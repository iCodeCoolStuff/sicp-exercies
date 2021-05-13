; Prediction: The program will run in an infinite loop because the program will always evaluate what is inside the parenthesis before continuing on with the rest of the expression.

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
	(else else-clause)))

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
	  guess
	  (sqrt-iter (improve guess x) x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (test)
  (sqrt-iter 1.0 2))

; Surely enough, the program exceeds recursion depth.
