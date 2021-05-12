(define (compose f g) (lambda (x) (f (g x))))
(define (repeated f n)
  (define (rec i)
    (if (= i 1) (lambda (x) (f x)) (compose f (rec (- i 1)))))
  (rec n)) 

(define (test)
  ((repeated square 2) 5))
