(define (filtered-accumulate filter combiner null-value term a next b)
  (cond ((> a b) null-value)
        ((filter a b) (combiner (term a) (filtered-accumulate filter combiner null-value term (next a) next b)))
	(else (filtered-accumulate filter combiner null-value term (next a) next b))
  )
)

(define (smallest-divisor n ) (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
	((divides? test-divisor n) test-divisor)
	(else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b) (= (remainder b a) 0))

(define (prime? n throwaway)
  (= n (smallest-divisor n)))

(define (inc x) (+ x 1))

(define (test)
  (filtered-accumulate prime? + 0 square 2 inc 100)
)

(define (identity x) x)

(define (gcd-1 x y)
  (cond ((= x y) #f)
        ((= (gcd x y) 1) #t)
  )
)

(define (relative-prime? x y) (= (gcd x y) 1))

(define (test2)
  (filtered-accumulate relative-prime? * 1 identity 1 inc 10)
)
