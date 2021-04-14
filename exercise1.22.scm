(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (prime? n)
    (report-prime (- (runtime) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (smallest-divisor n ) (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
	((divides? test-divisor n) test-divisor)
	(else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b) (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (search-for-primes n k)
  (if (= n (+ k 1)) 0
    (wrapper n k)))

(define (wrapper n k)
  (timed-prime-test n)
  (search-for-primes (+ n 1) k))


;;; Since computers are way faster than they were before, the times are basically zero for numbers even up to 1 million. Let's assume that the time is Theta(sqrt(n))
