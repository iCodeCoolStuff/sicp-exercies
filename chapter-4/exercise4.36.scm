; Using an-integer-starting-from would not work in this case because 
; a-pythagorean-triple would select the next integer from k. For example,
; an-integer-starting from. For example, i0 = 1, j0=1, k0 = 1. The next set of integers
; would be i1 = 1, j1 = 1, k1 = 2. And not cover all possibilities where i and j are not
; both equal to 1.

(define (require p)
  (if (not p) (amb)))

(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high)))

(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))

(define (pythagorean-triples)
  (let ((k (an-integer-starting-from 1)))
    (let ((i (an-integer-between 1 k)))
      (let ((j (an-integer-between i k)))
	(display (list i j k))(newline)
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))
