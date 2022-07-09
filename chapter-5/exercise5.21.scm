; a)

(make-machine
  '(tree left right stack)
  (list)
  '(start
     (assign stack (const '()))
   rec
     (test (op null?) (reg tree))
     (branch (label empty-tree))
     (test (op not-pair?) (reg tree))
     (branch (label leaf))
     (assign left (op car) (reg tree))
     (assign right (op cdr) (reg tree))
     (assign stack (op cons) (reg right) (reg stack))
     (assign tree (reg left))
     (goto (label rec))
   empty-tree
     (test (op null?) (reg stack))
     (branch (label done))
     (assign right (const 0))
     (assign left (op car) (reg stack))
     (goto (label add))
   leaf
     (assign left (const 1))
     (assign right (op car) (reg stack))
     (assign stack (op cdr) (reg stack))
     (assign stack (op cons) (reg left) (reg stack))
     (assign tree  (reg right))
     (goto (label rec))
   add
     (assign stack (op cdr) (reg stack))
     (assign right (op +) (reg left) (reg right))
     (test (op null?) (reg stack))
     (branch done)
     (assign left (op car) (reg stack))
     (test (op not-pair?) (reg left))
     (branch (label add))
     (assign tree (op car) (reg stack))
     (assign stack (op cdr) (reg stack))
     (assign stack (op cons) (reg right) (reg stack))
     (goto (label rec))
   done))

; b)

(make-machine
  '(tree left right stack n)
  (list (list 'null? null?) (list '+ +) (list 'not-pair? (lambda (n) (not (pair? n)))))
  '(start
     (assign n (const 0))
     (assign stack (const '()))
   rec
     (test (op null?) (reg tree))
     (branch (label empty-tree))
     (test (op not-pair?) (reg tree))
     (branch (label leaf))
     (assign left (op car) tree)
     (assign right (op cdr) tree)
     (assign stack (op cons) (reg right) (reg stack))
     (assign tree (reg left))
     (goto (label rec))
   empty-tree
     (test (op null?) (reg stack))
     (branch (label done))
     (assign tree (op car) (reg stack))
     (assign stack (op cdr) (reg stack))
     (goto (label rec))
   leaf
     (assign n (op +) (reg n) (const 1))
     (assign tree (op car) (reg stack))
     (assign stack (op cdr) (reg stack))
     (goto (label rec))
   done))
