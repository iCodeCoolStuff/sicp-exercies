(define (test)
  (define p1 (make-poly 'x (list (make-term 2 1) (make-term 1 -2) (make-term 0 1))))
  (define p2 (make-poly 'x (list (make-term 2 11) (make-term 0 7))))
  (define p3 (make-poly 'x (list (make-term 1 13) (make-term 0 5))))
  (define q1 (mul p1 p2))
  (define q2 (mul p1 p3))
  (greatest-common-divisor q1 q2))

; Value: (polynomial x (2 1458/169) (1 -2916/169) (0 1458/169))

