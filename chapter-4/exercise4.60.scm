; This happens because the query system looks for *all* variables ?person1 and ?person2 that satisfy lives-near. Within the query language, this is impossible. not filters out symmetric queries.
; Tbe only way to do this is to either use a special form or a hack with lisp-value that filters
; out data based on a certain characteristic of that data. The latter is not a robust solution.
