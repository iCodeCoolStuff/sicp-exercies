(define (pairs s t)
  (cons-stream 
    (list (stream-car s) (stream-car t))
    (interleave
      (stream-map (lambda (x) (list (stream-car s) x))
		  (stream-cdr t))
      (pairs (stream-cdr s) (stream-cdr t)))))

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
		   (interleave s2 (stream-cdr s1)))))

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))

(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
	(else
	  (let ((s1car (stream-car s1))
		(s2car (stream-car s2)))
	    (cond ((< (weight s1car) (weight s2car))
		   (cons-stream
		     s1car
		     (merge-weighted (stream-cdr s1) s2 weight)))
	          ((> (weight s1car) (weight s2car))
		   (cons-stream
		     s2car
		     (merge-weighted s1 (stream-cdr s2) weight)))
		  (else
		    (cons-stream
		      s1car
		      (cons-stream
			s2car
		        (merge-weighted (stream-cdr s1)
			       (stream-cdr s2) weight)))))))))

(define (weighted-pairs s t weight)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (merge-weighted
      (stream-map (lambda (x) (list (stream-car s) x))
		  (stream-cdr t))
      (weighted-pairs (stream-cdr s) (stream-cdr t) weight) weight)))

(define (display-line x) (newline) (display x))
(define (display-stream s)
  (stream-for-each display-line s))

(define (test)
  (define (proc p)
    (+ (car p) (cadr p)))
  (define (proc2 p)
    (+ (* 2 (car p)) (* 3 (cadr p)) (* 5 (car p) (cadr p))))


  (define s (weighted-pairs integers integers proc))
  (define (divisible? x y) (= (remainder x y) 0))
  (define (not-divisible? p) (not (or (divisible? (car p) 2) (divisible? (car p) 3) (divisible? (car p) 5)
				      (divisible? (cadr p) 2) (divisible? (cadr p) 3) (divisible? (cadr p) 5))))
  (define s2 (stream-filter not-divisible? (weighted-pairs integers integers proc2)))

  (define (stream-iter s)
    (if (not (and (= (car (stream-car s)) 13) (= (cadr (stream-car s)) 17)))
	(begin (display-line (stream-car s))
	       (stream-iter (stream-cdr s)))))
  (stream-iter s2))
