(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (area x1 x2 y1 y2)
  (* (- x2 x1) (- y2 y1)))

(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
      (/ passed (+ passed failed))
	 (monte-carlo
	   (stream-cdr experiment-stream) passed failed)))
    (if (stream-car experiment-stream)
	(next (+ passed 1) failed)
	(next passed (+ failed 1))))

(define (map-successive-pairs f s)
  (cons-stream
    (f (stream-car s) (stream-car (stream-cdr s)))
    (map-successive-pairs f (stream-cdr (stream-cdr s)))))

(define (estimate-integral pred x1 x2 y1 y2)
  (define (make-random-pairs)
    (cons-stream
      (random-in-range x1 x2)
      (cons-stream
	(random-in-range y1 y2)
	(make-random-pairs))))
  (define integral-experiment
    (map-successive-pairs pred (make-random-pairs)))
  (stream-map (lambda (n) (* n (area x1 x2 y1 y2))) (monte-carlo integral-experiment 0 0)))

(define pi-estimate
  (estimate-integral (lambda (x y) (<= (+ (square x) (square y)) 1)) -1.0 1.0 -1.0 1.0))

(define (test)
  (stream-ref pi-estimate 10000))
