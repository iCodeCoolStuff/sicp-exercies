(define (make-interval a b) (cons a b))
(define (upper-bound c) (cdr c))
(define (lower-bound c) (car c))

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

(define (make-center-percent c percent)
  (make-interval (* c (- 1 percent)) (* c (+ 1 percent))))

(define (percent i)
  (/ (width i) (center i)))

(define (test)
  (percent (make-center-percent 2 0.95)))
