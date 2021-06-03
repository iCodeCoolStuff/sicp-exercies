;(define (count-leaves x)
  ;(cond ((null? x) 0)  
        ;((not (pair? x)) 1)
        ;(else (+ (count-leaves (car x))
                 ;(count-leaves (cdr x))))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
	  (accumulate op initial (cdr sequence)))))

(define (enumerate-tree tree)
  (cond ((null? tree) ())
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))


(define (count-leaves t)
  (accumulate (lambda (x y) (+ 1 y)) 0 (map values (enumerate-tree t))))

(define (test)
  (count-leaves (enumerate-tree (list 1 (list 2 (list 3 4)) 5))))
