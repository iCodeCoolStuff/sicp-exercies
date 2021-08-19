(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
		 (add-streams (scale-stream integrand dt)
					    int)))
  int)

(define (add-streams s1 s2) (stream-map + s1 s2))
(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor))
	      stream))

(define (RC R C dt)
  (lambda (current-stream v0)
    (cons-stream
      v0
      (add-streams (scale-stream current-stream R)
		   (scale-stream (integral current-stream v0 dt) (/ 1 C))))))

(define RC1 (RC 5 1 0.5))
(define s (RC1 integers 0))
