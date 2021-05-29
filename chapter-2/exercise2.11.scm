(define (make-interval a b) (cons a b))
(define (upper-bound c) (cdr c))
(define (lower-bound c) (car c))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
		   (max p1 p2 p3 p4))))


(define (mul-interval2 x y)
  (cond ((and (positive? (lower-bound x)) (positive? (lower-bound y)))
		      (make-interval (* (lower-bound x) (upper-bound y))
							 (* (upper-bound x) (upper-bound y))))
		((and (negative? (upper-bound x)) (negative? (upper-bound y)))
		      (make-interval (* (upper-bound x) (upper-bound y))
							 (* (lower-bound x) (lower-bound y))))
		((and (negative? (upper-bound x)) (positive? (lower-bound y)))
		      (make-interval (* (lower-bound x) (upper-bound y))
							 (* (upper-bound x) (lower-bound y))))
		((and (positive? (lower-bound x)) (negative? (upper-bound y)))
		      (make-interval (* (upper-bound x) (lower-bound y))
							 (* (lower-bound x) (upper-bound y))))
		((and (negative? (lower-bound x)) (positive? (lower-bound y)))
		      (make-interval (* (lower-bound x) (upper-bound y))
							 (* (upper-bound x) (upper-bound y))))
		((and (positive? (lower-bound x)) (negative? (lower-bound y)))
		      (make-interval (* (upper-bound x) (lower-bound y))
							 (* (upper-bound x) (upper-bound y))))
		((and (negative? (upper-bound x)) (positive? (upper-bound y)))
		      (make-interval (* (lower-bound x) (upper-bound y))
							 (* (upper-bound x) (lower-bound y))))
;Nine Cases:
;(1, 2) (3, 4)     #pos low x and pos low y
;(-1, 2) (3, 4)    #neg low x and pos low y
;(1, 2) (-3, 4)    #pos low x and neg low y
;(-1, -2) (3, 4)   #neg up  x and pos low y
;(-1, 2) (-3, 4)    >2 multiplications     neg low x and neg low y
;(1, 2) (-3, -4)   #pos low x and neg up  y
;(-1, -2) (-3, 4)  #neg up  x and pos up  y
;(-1, 2) (-3, -4)   pos up  x and neg low y
;(-1, -2) (-3, -4) #neg up  x and neg up  y

;(1, 2) (-4, -3)
;(-2, -1) (-3, 4)   neg up  x and pos up  y
