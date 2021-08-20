; Louis reasoner puts a subtle bug in the program where the program uses avpt as the last-value instead of the raw
; value from the input stream. In order to fix this, an additional last-avpt argument should be added to make-zero-crossings
; to compare the current smoothed point with the last smoothed point.

(define alternate
  (cons-stream
    1
    (stream-map (lambda (x) (* x -1))
		alternate)))

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

(define (test)
  (define s (make-zero-crossings sine 0 0))
  s)
