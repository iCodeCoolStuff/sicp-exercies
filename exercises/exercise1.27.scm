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

(define (fermat-fails-all-a n)
  (define (fermat a)
    (cond ((= a 1) true)
	  ((not (= (expmod a n n) a)) false)
    	  (else (fermat (- a 1)))))
      ;(else (if (not (= (expmod a n n) a)) false (fermat (- a 1))))))
  (fermat (- n 1)))
