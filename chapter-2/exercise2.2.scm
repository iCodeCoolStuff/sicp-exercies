(define (make-segment point1 point2)
  (cons point1 point2))

(define (make-point x y)
  (cons x y))

(define (start-segment segment)
  (car segment))

(define (end-segment segment)
  (cdr segment))

(define (x-point point)
  (car point))

(define (y-point point)
  (cdr point))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (midpoint segment)
  (make-point 
    (/ 
      (+ (x-point (start-segment segment))
         (x-point (end-segment segment))) 2)
    (/
      (+ (y-point (start-segment segment))
         (y-point (end-segment segment))) 2)))

(define (test)
  (print-point
    (midpoint
      (make-segment 
        (make-point 0 0)
        (make-point 3 3)))))
