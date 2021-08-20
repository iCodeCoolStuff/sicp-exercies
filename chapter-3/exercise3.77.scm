(define (add-streams s1 s2) (stream-map + s1 s2))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor))
	      stream))

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

(define (test)
  (stream-ref (solve (lambda (y) y)
		    1
		    0.001)
	      1000))

(define (integral delayed-integrand initial-value dt)
  (cons-stream
    initial-value
    (if (stream-null? (force delayed-integrand))
	the-empty-stream
	(integral (delay (stream-cdr (force delayed-integrand)))
		  (+ (* dt (stream-car (force delayed-integrand)))
		     initial-value)
		  dt))))
