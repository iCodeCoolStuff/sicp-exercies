(define (expmod base e m)
  (cond ((= e 0) 1)
	((even? e )
	 (remainder
	   (square (expmod base (/ e 2) m))
	   m))
	(else
	  (remainder
	    (* base (expmod base (- e 1) m))
	    m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
	((fermat-test n) (fast-prime? n (- times 1)))
	(else false)))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (fast-prime? n 3)
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


; The procedure completed really fast, and there was no 1e-9 anywhere. Just 0. This version is much faster than the one with a regular prime? function.
