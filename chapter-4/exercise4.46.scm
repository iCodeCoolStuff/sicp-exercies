; The parser wouldn't work because the prepositional phrases at the end of the sentence
; only have one possible form which is (<some-other-phrase> (list 'prep (parse-word prepositions))).
; This would always result to a parse tree that has the form
; (noun-phrase (verb-phrase (prep-phrase (prep-phrase (prep-phrase)))). 
