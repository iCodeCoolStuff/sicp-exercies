(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))

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

(define (display-line x) (newline) (display x))
(define (display-stream s)
  (stream-for-each display-line s))

(define (pairs-but-not-i-is-less-than-equal-to-j s t)
  (cons-stream 
    (list (stream-car s) (stream-car t))
    (interleave
      (stream-map (lambda (x) (list (stream-car s) x))
		  (stream-cdr t))
      (interleave
	(pairs-but-better (stream-cdr s) t)
        (pairs (stream-cdr s) (stream-cdr t))))))

(define (pairs-but-better s t)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (interleave
      (stream-map (lambda (x) (list x (stream-car t)))
		  (stream-cdr s))
      (pairs-but-better (stream-cdr s) (stream-cdr t)))))

(define (test)
  (define s (pairs-but-not-i-is-less-than-equal-to-j integers integers))
  (define (stream-iter s)
    (if (not (and (= (car (stream-car s)) 1) (= (cadr (stream-car s)) 100)))
	(begin (display-line (stream-car s))
	       (stream-iter (stream-cdr s)))))
  (stream-iter s))

(define (test2)
  (define s (pairs-but-better (stream-cdr integers) integers))
  (define (stream-iter s)
    (if (not (and (= (car (stream-car s)) 100) (= (cadr (stream-car s)) 1)))
	(begin (display-line (stream-car s))
	       (stream-iter (stream-cdr s)))))
  (stream-iter s))
