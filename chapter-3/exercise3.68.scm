(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
		   (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
  (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
		  t)
    (pairs (stream-cdr s) (stream-cdr t))))

(define (test)
  (define s (pairs integers integers))
  s)

; The interleave function recurses indefinitely because there is no cons-stream delaying the evaluation of interleave.
