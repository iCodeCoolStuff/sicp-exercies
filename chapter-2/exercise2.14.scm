(define make-interval cons)
(define (upper-bound i) (cdr i))
(define (lower-bound i) (car i))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-interval x 
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y)))))

(define (make-center-percent c percent)
  (make-interval (* c (- 1 percent)) (* c (+ 1 percent))))

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

(define (test)
  (let ((a (make-interval 1 2))
	(b (make-interval 3 4))
	(c (make-interval 1 1))
        (d (make-center-percent 1 0.001)))
    ;(display (div-interval (make-interval 1 1) a))
    (display (div-interval d c))))

(define (test2)
  (let ((a (make-center-percent 2 0.00001))
	(b (make-center-percent 3 0.00001)))
	(display (div-interval a b))(newline)
	(display (par1 a b))(newline)
	(display (par2 a b))))

;(div-interval (make-interval 1 1) (make-interval 1.999 2.001)) resolves to (1/2.001 . 1/1.999)
; so the intervals will be different in the second formula for parallel resistors.
