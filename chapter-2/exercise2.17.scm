(define (last-pair l)
  (if (null? (cdr l))
    l
    (last-pair (cdr l))))

(define (test)
  (last-pair (list 1 2 3 4 5))) 
