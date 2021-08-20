(define pi 3.141592654)

(define (numbers-plus-pi-6 n)
  (cons-stream n (numbers-plus-pi-6 (+ (/ pi 6) n))))

(define sine
  (stream-map sin (numbers-plus-pi-6 0)))

(define (make-zero-crossings input-stream last-value last-avpt)
  (let ((avpt (/ (+ (stream-car input-stream)
		    last-value)
		 2)))
    (cons-stream
      (sign-change-detector avpt last-avpt)
      (make-zero-crossings
	(stream-cdr input-stream) (stream-car input-stream) avpt))))

(define (display-line x) (newline) (display x))
(define (display-stream s)
  (stream-for-each display-line s))

(define (sign-change-detector fst snd)
  (cond ((and (>= fst 0) (negative? snd)) 1)
        ((and (negative? fst) (>= snd 0)) -1)
	(else 0)))

(define (smooth s)
  (let ((current-element (stream-car s))
	(next-element (stream-car (stream-cdr s))))
    (let ((avg (/ (+ current-element next-element) 2)))
      (cons-stream
	avg
	(smooth (stream-cdr s))))))

(define (make-zero-crossings input-stream)
  (define (make-zc s last-avpt)
    (let ((avpt (stream-car (smooth s))))
      (cons-stream
	(sign-change-detector avpt last-avpt)
	(make-zc (stream-cdr s) avpt))))
  (make-zc input-stream 0))

(define (test)
  (define s (make-zero-crossings sine))
  s)
