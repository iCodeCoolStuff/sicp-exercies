(define (make-accumulator sum)
  (lambda (amount)
    (begin (set! sum (+ sum amount))
	     sum)))

(define A1 (make-accumulator 100))
