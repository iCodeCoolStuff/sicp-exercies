(define (make-interval a b) (cons a b))
(define (upper-bound c) (car c))
(define (lower-bound c) (cdr c))

(define (sub-interval x y)
  (make-interval (- (lower-bound y) (lower-bound x))
		 (- (upper-bound y) (upper-bound x))))

; The difference between two intervals may be computed by subtracting the lower bound of the first interval from the second. The same goes for the upper bound.
