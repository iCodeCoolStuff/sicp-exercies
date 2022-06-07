; (?relationship Adam Irad) will always evaluate to ((great grandson) Adam Irad) and ((great great . son) Adam Irad) due to an ambiguous grammar.
(assert! (rule ((grandson) ?x ?y) (grandson ?x ?y)))
(assert! (rule ((great . ?rel) ?x ?y)
               (and (?rel ?x ?z)
                    (son ?z ?y))))
