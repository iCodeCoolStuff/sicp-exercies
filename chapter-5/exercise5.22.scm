; a)

(make-machine
  '(list1 list2 stack t)
  (list (list 'null? null?))
  '(start
     (assign stack (const '()))
   rec
     (test (op null?) (reg list1))
     (branch (label add))
     (assign t (op car) (reg list1))
     (assign stack (op cons) (reg t) (reg stack))
     (assign list1 (op cdr) (reg list1))
     (goto (label rec))
   add
     (test (op null?) (reg stack))
     (branch (label done))
     (assign t (op car) (reg stack))
     (assign stack (op cdr) (reg stack))
     (assign list2 (op cons) (reg t) (reg list2))
     (goto (label add))
   done))

; b)

(make-machine
  '(list1 list2 t)
  (list (list 'null? null?))
  '(rec
     (assign t (op cdr) (reg list1))
     (test (op null?) (reg t))
     (branch (label end))
     (assign list1 (op cdr) (reg list1))
     (goto (label rec))
   end
     (perform (op set-cdr!) (reg list1) (reg list2))
     (goto (label done))
   done))
