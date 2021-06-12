(define (element-of-set? x set)
  (cond ((null? (car set)) #f)
        ((= (car set) x)   #t)
        ((> (car set) x)   #f)
	(else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (if (element-of-set? x set)
      set
      (insert x set)))

(define (insert x set)
  (cond ((null? set) (list x))
        ((> (car set) x) (cons x set))
        (else (cons (car set) (insert x (cdr set))))))
