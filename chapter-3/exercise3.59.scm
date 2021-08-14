(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))
(define (mul-streams s1 s2) (stream-map * s1 s2))
(define ones (cons-stream 1 ones))
(define negative-ones (cons-stream -1 negative-ones))

; a)
(define (integrate-series s)
  (mul-streams (stream-map (lambda (n) (/ 1 n)) integers) s))

; b)

(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

(define cosine-series (cons-stream 1 (integrate-series (mul-streams negative-ones sine-series))))
(define sine-series (cons-stream 0 (integrate-series cosine-series)))
