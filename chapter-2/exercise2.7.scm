(define (make-interval a b) (cons a b))

(define (upper-bound c) (car c))
(define (lower-bound c) (cdr c))
