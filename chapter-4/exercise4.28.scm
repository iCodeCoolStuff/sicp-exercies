(define (fact n)
  (if (= n 0)
      1
      (* n (fact (- n 1)))))

; If fact was used without actual-value used in apply, it would throw an error saying that fact is an unknown
; procedure type when in fact it tried to evaluate the name of the procedure (fact) instead of the actual
; value of fact.
