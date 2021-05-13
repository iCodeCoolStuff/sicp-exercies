(define (filtered-accumulate filter combiner null-value term a next b)
  (cond ((> a b) null-value)
        ((filter a) (combiner (term a) (filtered-accumulate filter combiner null-value term (next a) next b)))
	(else (filtered-accumulate filter combiner null-value term (next a) next b))
  )
)

(define (smallest-divisor n ) (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
	((divides? test-divisor n) test-divisor)
	(else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b) (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (inc x) (+ x 1))

(define (test)
  (filtered-accumulate prime? + 0 square 2 inc 100)
)

(define (identity x) x)

(define (product-of-relative-prime n)
  (define (relative-prime? i) (= (gcd i n) 1))
  (filtered-accumulate relative-prime? * 1 identity 1 inc 10)
)

(define (test2)
  (product-of-relative-prime 10)
)

