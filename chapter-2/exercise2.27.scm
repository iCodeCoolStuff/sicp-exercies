(define (reverse l)
  (define (rev-r l1 l2)
    (if (null? l2)
	l1
	(rev-r (cons (car l2) l1) (cdr l2))))
  (rev-r () l))

(define (deep-reverse l)
  (define (rev-r l1 l2)
    (if (null? l2)
	l1
	(rev-r (cons (reverse (car l2)) l1) (cdr l2))))
  (rev-r () l))

(define (test)
  (define x (list (list 1 2) (list 3 4)))
  (deep-reverse x))
