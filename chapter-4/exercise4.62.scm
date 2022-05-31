(rule (last-pair (?x . ()) (?x)))
(rule (last-pair (?x . ?y) ?z)
      (last-pair ?y ?z))

; These rules don't work on (last-pair ?x (3)) because the evaluator can't guess
; what list (3) is the last pair of.
