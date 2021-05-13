(define (make-rat a b) 
  (cond ((and (< a 0) (< b 0)) (cons (- a) (- b)))
	((or  (< a 0) (< b 0)) (cons (negative a) (abs b)))
	(else (cons a b))))

(define (negative x)
  (if (< x 0) x (- x)))

(define (test)
  (make-rat -5 -3))
(define (test2)
  (make-rat -5 3))
(define (test3)
  (make-rat 5 3))
