(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))
(define (mul-streams s1 s2) (stream-map * s1 s2))
(define ones (cons-stream 1 ones))
(define (integrate-series s)
  (mul-streams (stream-map (lambda (n) (/ 1 n)) integers) s))
(define exp-series
  (cons-stream 1 (integrate-series exp-series)))
(define cosine-series (cons-stream 1 (integrate-series (mul-streams negative-ones sine-series))))
(define sine-series (cons-stream 0 (integrate-series cosine-series)))
(define negative-ones (cons-stream -1 negative-ones))
(define (add-streams s1 s2) (stream-map + s1 s2))
(define (partial-sums s) (add-streams s (cons-stream 0 (partial-sums s))))

(define (stream-limit s tolerance)
  (let ((first-ele (stream-car s))
	(second-ele (stream-car (stream-cdr s))))
    (if (< (abs (- second-ele first-ele)) tolerance)
	second-ele
	(stream-limit (stream-cdr s) tolerance))))

(define (num-stream n)
  (cons-stream n (num-stream (* n -1))))

(define alternating-ones
  (num-stream 1.0))
  

(define log-series
  (integrate-series alternating-ones))

(define log-stream
  (partial-sums log-series))

(define (ln2 tolerance)
  (stream-limit log-stream tolerance))

; tolerance of 0.1: 21 terms
; tolerance of 0.01 201 terms
; tolerance of 0.0001: 20001 terms
