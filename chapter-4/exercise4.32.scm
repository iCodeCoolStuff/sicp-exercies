; Lazy lists are useful because they reduce the amount of redundant computation.

; This type of laziness can be taken advantage of to compute square roots efficiently using Newton's method.
; Each iteration of Newton's method only has to be calculated once. It does not have to be recalculated each time as with streams.

; Lazier lists can also avoid performing expensive computation until it is needed. In the sieve example from chapter 3:

(define (sieve stream)
  (cons-stream
   (stream-car stream)
   (sieve (stream-filter
           (lambda (x)
             (not (divisible? x (stream-car stream))))
           (stream-cdr stream)))))

(define primes (sieve (integers-starting-from 2)))

; Sieve does not have to calculate and store each prime. Sieve can simply delay the evaluation in the form of thunks until the value is needed.

; This extra laziness mostly results in more "efficient" programs.
