(define (has-cycle? lst)
  (if (null? lst)
      #f
      (let ((prev-pairs '()))
        (define (cycle-rec l)
          (cond ((null? l) #f)
	        ((memq (car l) prev-pairs) #t)
	        (else (begin (set! prev-pairs (cons (car l) prev-pairs))
		             (cycle-rec (cdr l))))))
        (cycle-rec lst))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define (test)
  (has-cycle? (list 1 2 3)))

(define (test2)
  (has-cycle? (make-cycle (list 1 2 3))))
