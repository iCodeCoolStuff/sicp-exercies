(define (tree-map func tree)
  (cond ((null? tree) ())
        ((not (pair? tree)) (func tree))
	(else (cons (tree-map func (car tree))
		    (tree-map func (cdr tree))))))

(define (square-tree tree) (tree-map square tree))
