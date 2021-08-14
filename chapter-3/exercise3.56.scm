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
(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
	(else
	  (let ((s1car (stream-car s1))
		(s2car (stream-car s2)))
	    (cond ((< s1car s2car)
		   (cons-stream
		     s1car
		     (merge (stream-cdr s1) s2)))
	          ((> s1car s2car)
		   (cons-stream
		     s2car
		     (merge s1 (stream-cdr s2))))
		  (else
		    (cons-stream
		      s1car
		      (merge (stream-cdr s1)
			     (stream-cdr s2)))))))))

(define twos   (stream-filter (lambda (n) (= (remainder n 2) 0)) integers))
(define threes (stream-filter (lambda (n) (= (remainder n 3) 0)) integers))
(define fives  (stream-filter (lambda (n) (= (remainder n 5) 0)) integers))
(define S (cons-stream 1 (merge (merge twos threes) fives)))
