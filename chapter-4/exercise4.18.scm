; This procedure will not work because the values of y and dy have to be evaluated before they are
; assigned to their respective variables. Evaluating the definition of dy will throw an error since
; f is not assigned yet.

; Scanning out the definitions as shown in the text will not work either because apply will evaluate
; the definition values before lambda has a chance to set y and dy.
