; disjoin and stream-flatmap interleave the streams so that infinite streams
; will not block out results of other streams needing to be merged.

; flatmap

; If there were an infinite amount of assertions that match a specific pattern, the system
; would not print out any other streams that match a different pattern.

(assert! (ones ()))
(assert! (rule (ones (1 . ?x)) (ones ?x)))

(assert! (twos ()))
(assert! (rule (twos (2 . ?x)) (twos ?x)))

doing (and (ones ?x) (twos ?y)) in an interleave-delayed system would interleave results with possible values of ?x and ?y.
doing (and (ones ?x) (twos ?y)) in a stream-append-delayed system would result with ?x being () and ?y being any list of 2's.

; disjunction

(rule (one ?x ?y)
      (or (two ?x ?y)
          (same ?x ?y)))

(rule (two ?x ?y)
      (or (same ?y ?y)
          (one ?x ?y)))

; If stream-append-delayed was used on (one 1 ?x), a stream of (one 1 ?x-n) would be 
; printed forever. With interleave, a correct unification of (one 1 1) gets printed 
; every other time along with (one 1 ?x-n) where n is a number.
