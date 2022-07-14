 (define eceval-operations
   (list
    ...
    (list 'cond-clauses cond-clauses)
    (list 'cond-predicate cond-predicate)
    (list 'cond-else-clause? cond-else-clause?)
    (list 'cond-actions cond-actions)
    ...))
 
ev-cond
  (assign exp (op cond->if) (reg exp))
  (goto (label ev-if))
  (assign unev (op cond-clauses) (reg exp))
  (save continue)
  (goto (label ev-clauses))
ev-clauses
  (assign exp (op first-exp) (reg unev))
  (test (op cond-else-clause?) (reg exp))
  (branch (label ev-cond-else))
  (save exp)
  (save env)
  (save continue)
  (save unev)
  (assign exp (op cond-predicate) (reg exp))
  (assign continue (label ev-cond-pred))
  (goto (label eval-dispatch))
ev-cond-pred
  (restore unev)
  (restore continue)
  (restore env)
  (restore exp)
  (test (op true?) (reg val))
  (branch (label ev-cond-result))
  (assign unev (op rest-exps) (reg unev))
  (goto (label ev-clauses))
ev-cond-result
  (assign unev (op cond-actions) (reg exp))
  (goto (label ev-sequence))
ev-cond-else
  (goto (label ev-cond-result))
