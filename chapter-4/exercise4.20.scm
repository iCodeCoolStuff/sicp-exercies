(define (letrec? exp) (tagged-list? exp 'letrec))
(define (letrec-bindings exp) (cadr exp))
(define (letrec-variables exp) (map car (letrec-bindings exp)))
(define (letrec-exps      exp) (map cadr (letrec-bindings exp)))
(define (letrec-body exp) (cddr exp))
(define (letrec->let exp) (make-transformed-let (letrec-variables exp) (letrec-exps exp) (letrec-body exp)))

;         +-------------+
; global: |             |
;         +-------------+
;               ^
;               |              
;         +-------------+    +------------------------+
;     f:  | x: 5        |<---| <rest-of-f-expression> |
;         +-------------+    +------------------------+
;               ^
;               |
;         +------------------------+
;    let: | even? (lambda (n) ...) |
;         | odd?  (lambda (n) ...) |
;         +------------------------+
