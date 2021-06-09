(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((upper (up-split painter (- n 1))))
        (below painter (beside upper upper)))))
