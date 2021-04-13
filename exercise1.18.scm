(define (*-iter a b c)
  (cond ((= b 0) 0)
	((= b 1) (+ a c))
	((even? b) (*-iter (double a) (halve b) c))
	(else (*-iter a (- b 1) (+ c a)))))

(define (double n)
  (* n 2))

(define (halve n)
  (/ n 2))
