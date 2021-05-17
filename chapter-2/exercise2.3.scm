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

(define (perimeter rectangle)
  (+ (* 2 (len rectangle)) (* 2 (width rectangle))))

(define (area rectangle)
  (* (len rectangle) (width rectangle)))

(define (make-rectangle point1 point2 point3 point4)
  (cons
    (cons (make-segment point1 point2) (make-segment point3 point4))
    (cons (make-segment point1 point4) (make-segment point2 point3))))

(define (make-rectangle2 point1 point2 point3 point4)
  (cons
    (cons (make-segment point1 point2) (make-segment point1 point4))
    (cons (make-segment point3 point4) (make-segment point3 point2))))

(define (len rectangle)
  (distance (car (car rectangle))))

(define (width rectangle)
  (distance (cdr (cdr rectangle))))

(define (distance segment)
  (sqrt 
    (+ 
      (square 
	(- (x-point (start-segment segment)) (x-point (end-segment segment))))
      (square
	(- (y-point (start-segment segment)) (y-point (end-segment segment)))))))

(define (test)
  (display "Perimeter ")
  (display (perimeter (make-rectangle (make-point 0 0) (make-point 5 0) (make-point 5 5) (make-point 0 5))))
  (newline)
  (display "Perimeter diff representation: ")
  (display (perimeter (make-rectangle2 (make-point 0 0) (make-point 5 0) (make-point 5 5) (make-point 0 5))))
  (newline))

(define (test2)
  (display "Area: ")
  (display (area (make-rectangle (make-point 0 0) (make-point 5 0) (make-point 5 5) (make-point 0 5))))
  (newline)
  (display "Area diff representation: ")
  (display (area (make-rectangle2 (make-point 0 0) (make-point 5 0) (make-point 5 5) (make-point 0 5))))
  (newline))
