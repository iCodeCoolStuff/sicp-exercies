(define (add-streams s1 s2) (stream-map + s1 s2))
(define (mul-streams s1 s2) (stream-map * s1 s2))
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

(define (sub-series s1 s2)
  (stream-map - s1 s2))

(define (one-over-series s)
  (stream-map (lambda (n) (/ 1 n)) s))

(define (s-sub-r s)
  (stream-cdr s))

(define ones
  (cons-stream 1 ones))

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define integers
  (integers-starting-from 1))

(define negative-ones
  (cons-stream -1 negative-ones))

(define twos
  (cons-stream 2 twos))

(define (invert-unit-series S)
  (define X
    (cons-stream
      1
      (mul-series (mul-series negative-ones (s-sub-r S)) X)))
  X)
