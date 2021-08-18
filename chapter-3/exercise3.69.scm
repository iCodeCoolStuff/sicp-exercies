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

(define (triples s t u)
  (cons-stream
    (list (stream-car s) (stream-car t) (stream-car u))
    (interleave
      (stream-map (lambda (x) (list (stream-car s) (car x) (cadr x)))
		  (pairs t u))
      (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(define (pythagorean? triple)
  (let ((a2 (square (car triple)))
	(b2 (square (cadr triple)))
	(c2 (square (caddr triple))))
    (= (+ a2 b2) c2)))

(define pythagorean-triples
  (stream-filter pythagorean? (triples integers integers integers)))
