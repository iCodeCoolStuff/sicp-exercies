(define (subsets s)
  (if (null? s)
      (list ())
      (let ((rest (subsets (cdr s))))
	(append rest (map (lambda (x) (cons (car s) x)) rest)))))

; How it works:
; (subsets (list 1 2))
; -> (subsets (2 ())
; -> (subsets ())
; -> (append () (2))
; -> (append (() (2)) ((1) (1 2)))
;
; ;Value: (() (2) (1) (1 2))

