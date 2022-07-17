; a)

ev-application
  (save continue)
  (assign unev (op operands) (reg exp))
  (save unev)
  (assign exp (op operator) (reg exp))
  (test (op variable?) (reg exp))
  (branch (label no-save-env))
  (save env)
  (assign continue (label ev-appl-did-operator))
  (goto (label eval-dispatch))
no-save-env
  (assign continue (label ev-appl-no-restore-env))
  (goto (label eval-dispatch))
ev-appl-did-operator
  (restore env)
ev-appl-no-restore-env
  (restore unev)
  (assign argl (op empty-arglist))
  (assign proc (reg val))
  (test (op no-operands?) (reg unev))
  (branch (label apply-dispatch))
  (save proc)

; b)

This idea is prone to bugs, difficult to understand and modify, and will require much more effort to implement than a compiler.
