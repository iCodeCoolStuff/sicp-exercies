(define (stream-limit s tolerance)
  (let ((first-ele (stream-car s))
	(second-ele (stream-car (stream-cdr s))))
    (if (< (abs (- second-ele first-ele)) tolerance)
	second-ele
	(stream-limit (stream-cdr s) tolerance))))

(define (sqrt-stream x)
  (define guesses
    (cons-stream
      1.0
      (stream-map (lambda (guess) (sqrt-improve guess x))
		  guesses)))
  guesses)

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(define (test)
  (sqrt 2 0.0001))
