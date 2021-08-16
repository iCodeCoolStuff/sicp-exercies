(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))
(define (mul-streams s1 s2) (stream-map * s1 s2))
(define (add-streams s1 s2) (stream-map + s1 s2))
(define negative-ones
  (cons-stream -1 negative-ones))
(define (integrate-series s)
  (mul-streams (stream-map (lambda (n) (/ 1 n)) integers) s))
(define cosine-series (cons-stream 1 (integrate-series (mul-streams negative-ones sine-series))))
(define sine-series (cons-stream 0 (integrate-series cosine-series)))

(define (make-const-stream c)
  (define const-stream
    (cons-stream c const-stream))
  const-stream)

(define (mul-series s1 s2)
  (cons-stream
    (* (stream-car s1) (stream-car s2))
    (add-streams
      (mul-streams (make-const-stream (stream-car s1)) (stream-cdr s2))
      (mul-series (stream-cdr s1) s2))))

(define (s-sub-r s)
  (stream-cdr s))

(define (invert-unit-series S)
  (define X
    (cons-stream
      1
      (mul-series (mul-streams negative-ones (s-sub-r S)) X)))
  X)

(define (div-series num den)
  (if (= (stream-car den) 0)
      (error "cannot divide by zero -- DIV-SERIES" (list num den))
      (mul-series num (invert-unit-series den))))

(define t-series
  (div-series sine-series cosine-series))
