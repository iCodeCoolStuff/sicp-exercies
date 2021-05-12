(define (compose f g)
  (lambda (x) (f (g x))))

(define (inc x) (+ x 1))

(define (test)
  ((compose square inc) 6))
