;561
;1105
;1729
;2465
;2821
;6601

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

(define fermat-fails-all-a n)
  (cond ((= n 1) false)
	(else (if (= expmod a n n) true (fermat 


(define (fermat-test n)
  (
