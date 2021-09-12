(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

; Ben's argument:
; Using the factorial example from the text, the usual-value part of the unless statement won't be evaluated unless the condition is true.

; Alyssa's argument:
; Defining unless as a special form would make it equivalent to (if (not pred) consequent alternative).
; This makes it so that unless could not be used with (try 0 (/ 1 0)) (aka a higher-order procedure) to return 1 instead of an error.

(define (unless->if exp)
  (make-if (not (condition exp)) (usual-value exp) (exceptional-value exp)))

; It might be useful to have unless as a procedure when avoiding an expensive computation.
; For example, using lazy evaluation in a Newton's Method procedure can delay evaluating
; another iteration when the previous iteration is good enough to return.
