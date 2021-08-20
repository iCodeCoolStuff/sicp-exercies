(define (add-streams s1 s2) (stream-map + s1 s2))
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor))
	      stream))

(define (integral delayed-integrand initial-value dt)
  (cons-stream
    initial-value
    (if (stream-null? (force delayed-integrand))
	the-empty-stream
	(integral (delay (stream-cdr (force delayed-integrand)))
		  (+ (* dt (stream-car (force delayed-integrand)))
		     initial-value)
		  dt))))

(define (RLC R L C dt)
  (lambda (vC0 iL0)
    (define iL (integral (delay diL) iL0 dt))
    (define vC (integral (delay dvC) vC0 dt))
    (define dvC (scale-stream iL (/ -1 C)))
    (define diL (add-streams (scale-stream vC (/ 1 L)) (scale-stream iL (/ (* -1 R) L))))
    (cons-stream
      (cons vC0 iL0)
      (stream-map cons vC iL))))

(define (test)
  (define RC (RLC 1 1 0.2 0.1))
  (define circuit (RC 10 0))
  circuit)
