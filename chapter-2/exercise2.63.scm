(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
	      (cons (entry tree)
		    (tree->list-1
		      (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
	result-list
	(copy-to-list (left-branch tree)
		      (cons (entry tree)
			    (copy-to-list
			      (right-branch tree)
			      result-list)))))
  (copy-to-list tree '()))

(define (test)
  (define tree1 (make-tree 7 (make-tree 3 (make-tree 1 () ()) (make-tree 5 () ())) 
			     (make-tree 9 () (make-tree 11 () ()))))
  (define tree2 (make-tree 3 (make-tree 1 () ()) (make-tree 7 (make-tree 5 () ()) (make-tree 9 () (make-tree 11 () ())))))
  (define tree3 (make-tree 5 (make-tree 3 (make-tree 1 () ()) ()) (make-tree 9 (make-tree 7 () ()) (make-tree 11 () ()))))
  (display "tree1")(newline)
  (display (tree->list-1 tree1))(newline)
  (display (tree->list-2 tree1))(newline)
  (display "tree2")(newline)
  (display (tree->list-1 tree2))(newline)
  (display (tree->list-2 tree2))(newline)
  (display "tree3")(newline)
  (display (tree->list-1 tree3))(newline)
  (display (tree->list-2 tree3))(newline))

(define (test2)
  (define tree4 (make-tree 3 (make-tree 2 (make-tree 1 () ()) ()) (make-tree 4 () (make-tree 5 () ())))) 
  (define tree5 (make-tree 5 (make-tree 4 (make-tree 3 (make-tree 2 (make-tree 1 () ()) ()) ()) ()) ()))
  (display "tree4")(newline)
  (display (tree->list-1 tree4))(newline)
  (display (tree->list-2 tree4))(newline)
  (display "tree5")(newline)
  (display (tree->list-1 tree5))(newline)
  (display (tree->list-2 tree5))(newline))

; a
; Both trees produce the same result for every tree. They each produce (1 3 5 7 9 11)

; b
; Both trees have the same order of growth
