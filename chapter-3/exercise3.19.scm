;hacky but whatever
(define (has-cycle? lst)
  (if (null? lst)
      #f
      (let ((current-index 0))
           (define current-pair (lambda () (memq (list-ref lst current-index) lst)))
           (define next-pair    (lambda () (cdr (current-pair))))
           (define (cycle-iter)
	     (cond ((null? (current-pair)) #f)
	           ((null? (next-pair)) #f)
	           ((< (pair-index lst (next-pair)) current-index) #t)
	           (else (begin (set! current-index (+ current-index 1))
		                (cycle-iter)))))
           (cycle-iter)))

(define (pair-index lst pair)
  (define (index-iter l i)
    (cond ((null? l) (length lst))
          ((eq? l pair) i)
	  (else (index-iter (cdr l) (+ i 1)))))
  (index-iter lst 0))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define (test)
  (define a (make-cycle (list 1 2 3)))
  (has-cycle? a))

;(define (has-cycle? lst)
  ;(define (cycle-iter l)
    ;(cond ((null? l) #f)
          ;((> (length (cdr l) ) (length l)) #t)
	  ;(else (cycle-iter (cdr l)))))
  ;(cycle-iter lst))


  
