; a)

ev-application
  (save continue)
  (assign exp (op operator) (reg exp))
  (assign unev (op operands) (reg exp))
  (test (op quoted?) (reg exp))
  (branch (label ev-appl-no-restore))
  (save env)
  (save unev)
  (assign continue (label ev-appl-did-operator))
  (goto (label eval-dispatch))
ev-appl-did-operator
  (restore unev)
  (restore env)
ev-appl-no-restore
  (assign argl (op empty-arglist))
  (assign proc (reg val))
  (test (op no-operands?) (reg unev))
  (branch (label apply-dispatch))
  (save proc)

; b)

This idea is prone to bugs, difficult to understand and modify, and will require much more effort to implement than a compiler.
