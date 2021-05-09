(define (product term a next b)
  (define (product-iter a result)
    (if (= a (+ b 1)) result (product-iter (next a) (* (term a) result)))
  )
  (product-iter a 1)
)

(define (identity x) x)
(define (one x) 1)
(define (inc x) (+ x 1))
(define (dec x) (- x 1))
(define (even x) (if (even? x) x (+ x 1)))
(define (odd x) (if (odd? x) x (+ x 1)))

(define (test)
  (product identity 5 inc 10)
)

(define (factorial n)
  (product identity 1 inc n)
)

(define (pi n)
  (* 2 (/ (product even 1 inc n) (product odd 2 inc n)))
)

(define (product-rec term a next b)
  (if (= a b) b (* (term a) (product-rec term (next a) next b)))
)
