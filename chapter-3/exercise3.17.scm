(define (count-pairs x)
  (let ((counted-pairs '()))
    (define (count-rec y)
      (cond ((not (pair? y)) 0)
            ((memq y counted-pairs) (+ (count-rec (car y)) (count-rec (cdr y))))
	    (else 
	      (begin (set! counted-pairs (cons y counted-pairs))
		     (+ 1 (count-rec (car y)) (count-rec (cdr y)))))))
  (count-rec x)))

(define a (cons 'c 'c))
(define b (cons a a))
(define c (cons b b))

(define x (cons 'a 'b))
(define y (cons x '5))
(define z (cons x y))

(define test  (lambda () (count-pairs c)))
(define test2 (lambda () (count-pairs z)))
