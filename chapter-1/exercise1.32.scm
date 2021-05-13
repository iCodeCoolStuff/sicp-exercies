(define (accumulate combiner null-value term a next b)
  (if (= a null-value) (term b) (combiner (term a) (accumulate combiner null-value term (next a) next b)))
)

(define (sum term a next b)
  (accumulate + b term a next b)
)

(define (product term a next b)
  (accumulate * b term a next b)
)

(define (inc x) (+ x 1))
(define (identity x) x)

(define (test)
  (display (product identity 1 inc 8)) ;40320
  (display " ")
  (display (sum identity 1 inc 10))    ;55
)
