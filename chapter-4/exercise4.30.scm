; a)
; Ben is right about for-each because for-each always forces the value of lambda body.

; b)

; (p1 1) -> (1 2)
; (p2 1) -> 1

; After Cy's change:

; (p1 1) -> (1 2)
; (p2 1) -> (1 2)

; c)

; This is true because actual-value forces a delayed expression to fully evaluate and lets procedures such as for-each with side effects function normally.

; d)

; We might want to force the last expression in the sequence because there may be a nested side effect (for whatever reason)
; that would not take place if the last expression was not forced.
