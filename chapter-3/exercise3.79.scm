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

(define (solve-2nd-better f y0 dy0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (stream-map f dy y))
  y)

(define (test)
  (define f (lambda (dy y) y))
  (define s (solve-2nd-better f 2 -1 0.001))
  (stream-ref s 1000))
