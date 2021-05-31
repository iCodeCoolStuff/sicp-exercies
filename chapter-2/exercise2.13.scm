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

(define (percent-goated i1 i2)
  (+ (percent i1) (percent i2)))

(define (product i1 i2)
 (make-interval (* (lower-bound i1) (lower-bound i2)) (* (upper-bound i1) (upper-bound i2))))

(define (test)
  (display (percent (product (make-center-percent 2 0.0001) (make-center-percent 3 0.0001))))(newline)
  (display (percent-goated (make-center-percent 2 0.0001) (make-center-percent 3 0.0001))))
