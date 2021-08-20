(define (add-streams s1 s2) (stream-map + s1 s2))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor))
	      stream))

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

(define (integral delayed-integrand initial-value dt)
  (cons-stream
    initial-value
    (if (stream-null? (force delayed-integrand))
	the-empty-stream
	(integral (delay (stream-cdr (force delayed-integrand)))
		  (+ (* dt (stream-car (force delayed-integrand)))
		     initial-value)
		  dt))))

(define (solve-2nd a b dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (add-streams (scale-stream dy a) (scale-stream y b)))
  y)

(define (test)
  (define y (solve-2nd 1 2 0.001 1 0.5))
  (stream-ref y 100))
