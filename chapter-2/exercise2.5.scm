(define (cons a b)
  (* (exp-rec 2 a) (exp-rec 3 b)))

(define (car c)
  (define (car-iter int result)
    (if (not (= (remainder int 2) 0)) result (car-iter (/ int 2) (+ result 1))))
  (car-iter c 0))

(define (cdr c)
  (define (cdr-iter int result)
    (if (not (= (remainder int 3) 0)) result (cdr-iter (/ int 3) (+ result 1))))
  (cdr-iter c 0))

(define (exp-rec x y)
  (cond ((= y 0) 1)
	((even? y) (square (exp-rec x (/ y 2))))
	(else (* x (exp-rec x (- y 1))))))
