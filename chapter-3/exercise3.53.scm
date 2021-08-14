(define the-empty-stream '())
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))
(define (stream-map proc . argstreams)
  (if (null? (car argstreams))
      the-empty-stream
      (cons-stream
	(apply proc (map stream-car argstreams))
	(apply stream-map
	       (cons proc (map stream-cdr argstreams))))))
(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
		      (stream-filter
		        pred
		        (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))
(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))
(define (sieve stream)
  (cons-stream
    (stream-car stream)
    (sieve (stream-filter
	     (lambda (x)
	       (not (divisible? x (stream-car stream))))
	     (stream-cdr stream)))))
(define primes (sieve (integers-starting-from 2)))
(define (divisible? x y) (= (remainder x y) 0))
(define none (sieve (stream-filter (lambda (x) (divisible? x 5)) (integers-starting-from 1))))
(define ones (cons-stream 1 ones))
(define (add-streams s1 s2) (stream-map + s1 s2))
(define integers
  (cons-stream 1 (add-streams ones integers)))

(define fibs
  (cons-stream
    0
    (cons-stream 1 (add-streams (stream-cdr fibs) fibs))))

; Actual exercise

(define s (cons-stream 1 (add-streams s s)))
; This stream will return a sequence of 1->2->4->8->16->32 ... 2^n
