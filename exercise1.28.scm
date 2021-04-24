(define (expmod base exp m)
  (cond ((= exp 0) 1)
	((even? exp)
	  (if (= (remainder (square (expmod base (/ exp 2) m)) m) 1)
	    0
	    (square (expmod base (/ exp 2) m))))
	 (else
	   (remainder
	     (* base (expmod base (- exp 1) m))
	     m))))

(define (rabin-test n)
  (expmod (+ (random (- n 1)) 1) (- n 1) n))

;(remainder
;  (square (expmod base (/ exp 2) m))
;  m))



;This is about as far as I got. Don't really want to go down the rabbit hole of doing the rest of this
