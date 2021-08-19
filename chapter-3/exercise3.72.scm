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

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))

(define (display-line x) (newline) (display x))
(define (display-stream s)
  (stream-for-each display-line s))

(define (ram p)
  (+ (cube (car p)) (cube (cadr p))))
(define s (weighted-pairs integers integers ram))
(define (cube x) (* x x x))
(define (test)
  (define (stream-proc s)
    (let ((first (ram (stream-car s)))
	  (second (ram (stream-car (stream-cdr s))))
	  (third (ram (stream-car (stream-cdr (stream-cdr s))))))
      (if (and (= first second) (= first third))
	  (begin (display-line (stream-car s))
	         (display-line (stream-car (stream-cdr s)))
		 (display-line (stream-car (stream-cdr (stream-cdr s))))
	         (cons-stream
	           (stream-car s)
	           (stream-proc (stream-cdr s))))
	  (stream-proc (stream-cdr s)))))
    (define s-better (stream-proc s))
    s-better)
