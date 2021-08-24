;a)

; Louis's plan will fail because special forms such as define will be interpreted as procedure
; applications if the clause for procedure application comes first.

; b)

(define (application? exp) (tagged-list? exp 'call))
(define (operator exp) (cadr exp))
(define (operands exp) (cddr exp))
