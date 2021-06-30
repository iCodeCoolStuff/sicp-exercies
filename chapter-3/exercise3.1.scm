(define (make-accumulator sum)
  (lambda (amount)
    (begin (set! sum (+ sum amount))
	     sum)))

(define (test)
  (define a (make-accumulator 0))
  (a 10)
  (display a))
