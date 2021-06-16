; This works because the complex number selector methods were not registered for complex numbers. They were only registered
; for rectangular and polar representations of complex numbers.

; In the below example, you can see the magnitude procedure working on the general complex number and subsequently the rectangular
; represntation of the complex number.

; Example:
; (magnitude (z))
; (apply-generic 'magnitude z)
; (let ((proc (get 'magnutude '(complex)))))
; (apply magnitude (contents z))
; (magnitude ('rectangular (3 4)))
; (apply-generic 'magnitude ('rectangular (3 4)))
; (let ((proc (get 'magnutude 'rectangular))))
; (apply magnitude (3 4))
; (sqrt (+ (square 3) (square 4)))
; 5
