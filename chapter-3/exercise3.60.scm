;(define (stream-map proc . argstreams)
  ;(if (null? (car argstreams))
      ;the-empty-stream
      ;(cons-stream
	;(apply proc (map stream-car argstreams))
	;(apply stream-map
	       ;(cons proc (map stream-cdr argstreams))))))
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

(define sine-series-squared
  (mul-series sine-series sine-series))

(define cosine-series-squared
  (mul-series cosine-series cosine-series))

(define (test)
  (define s (add-streams sine-series-squared cosine-series-squared))
  s)

(define (test2)
  (define s (mul-series integers integers))
  s)
