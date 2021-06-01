(define (fringe t)
  (cond ((null? t) ())
        ((not (list? (car t))) t)
	(else (append (fringe (car t)) (fringe (cdr t))))))

(define (test)
  (define x (list (list 1 2) (list 3 4)))
  (display (fringe x))(newline)
  (display (fringe (list x x))))

