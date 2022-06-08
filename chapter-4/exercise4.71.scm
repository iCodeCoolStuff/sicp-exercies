; The (married Mickey ?who) query illustrates the difference of simple-query
; without stream-append-delayed. Without the delay, the system goes into an infinite loop.
; In the delayed version, the system still goes into an infinite loop, 
; but you get an answer of (married minnie mickey).

(rule (married ?x ?y)
      (married ?y ?x))

; an example of a query that would produce undesirable behavior is a rule with
; and or-query that calls itself recursively.

(rule (simply ?x ?y)
      (or (same ?x ?y)
          (simply ?x ?y)))

; When interleave-delayed is used, the first disjunct is evaluated and printed to the console.
; The system continues to evaluate the second disjunct and goes into an infinite loop.
; However, when interleave is used, both the first and second disjuncts are evaluated. Because
; scheme is an applicative-order evaluation language, both arguments to interleave must be
; evaluated before continuing other evaluations. Because of this, the system will evaluate
; the query in an infinite loop without printing to the console.
