(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (predicate x y)
  (>= (square 1) (+ (square x) (square y))))
  
(define (area x1 x2 y1 y2)
  (* (- x2 x1) (- y2 y1)))

(define (estimate-integral pred upper-bound lower-bound x1 x2 y1 y2 n-trials)
  (* (area x1 x2 y1 y2) (monte-carlo n-trials (lambda () (pred (random-in-range x1 x2) (random-in-range y1 y2))))))
(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
	   (display trials-passed)
	   (/ trials-passed trials))
          ((experiment)
	   (iter (- trials-remaining 1) (+ trials-passed 1)))
	  (else
	    (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

(define (test)
  (estimate-integral predicate 1.0 -1.0 -1.0 1.0 -1.0 1.0 100000))
