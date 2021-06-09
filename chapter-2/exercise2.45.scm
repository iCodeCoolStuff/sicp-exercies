(define (split proc1 proc2)
  (define (func painter n)
    (if (= n 0)
        painter
        (let ((secondary (func painter (- n 1))))
          (proc1 painter (proc2 secondary secondary)))))
  (lambda (painter n) (func painter n)))

(define right-split (split beside below))
(define up-split    (split below beside))
