(assert! (rule (reverse () ())))
(assert! (rule (reverse (?x) (?x))))
(assert! (rule (reverse (?x . ?y) ?z)
               (and (reverse ?y ?w)
                    (append-to-form ?w (?x) ?z))))
; With only these, the system will not work for (reverse ?x (1 2 3)). However, if we install the below rule, it works for both (as long as the system has an infinite loop detector installed).
(assert! (rule (reverse (?x . ?y) ?z)
               (and (append-to-form ?w (?x) ?z)
                    (reverse ?y ?w))))
