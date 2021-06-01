(define (tree-map tree func)
  (cond ((null? tree) ())
        ((not (pair? tree)) (func tree))
	(else (cons (tree-map (car tree) func)
		    (tree-map (cdr tree) func)))))
(define (test)
  (tree-map
    (list 1
      (list 2 (list 3 4) 5)
	(list 6 7)) square))
