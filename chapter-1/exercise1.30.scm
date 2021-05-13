(define (sum term a next b)
  (define (iter a result)
    (if (= a (+ b 1)) result (iter (next a) (+ result (term a))))
  )
  (iter a 0)
)

;(define (inc x) (+ x 1))
;(define (identity x) x)

;(define (test)
  ;(sum identity 1 inc 10)
;)
