(define (make-zero-crossings input-stream last-value)
  (cons-stream
    (sign-change-detector
      (stream-car input-stream)
      last-value)
    (make-zero-crossings
      (stream-cdr input-stream)
		  (stream-car input-stream))))

;(define zero-crossings
  ;(make-zero-crossings sense-data 0))

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

(define (sign-change-detector fst snd)
  (cond ((and (positive? fst) (negative? snd)) 1)
        ((and (negative? fst) (positive? snd)) -1)
	(else 0)))

(define zero-crossings
  (stream-map sign-change-detector
	      sine
	      (cons-stream
		0
		sine)))

(define (test)
  (define s (make-zero-crossings sine 0))
  s)
