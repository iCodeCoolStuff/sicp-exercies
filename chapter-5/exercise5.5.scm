; Factorial:
; (fact 6)
; 
; (stack)
; (stack (fact-done 6))
; (stack (after-fact 5) (fact-done 6))
; (stack (after-fact 4) (after-fact 5) (fact-done 6))
; (stack (after-fact 3) (after-fact 4) (after-fact 5) (fact-done 6))
; (stack (after-fact 2) (after-fact 3) (after-fact 4) (after-fact 5) (fact-done 6))
; (stack (after-fact 3) (after-fact 4) (after-fact 5) (fact-done 6))
; (stack (after-fact 4) (after-fact 5) (fact-done 6))
; (stack (after-fact 5) (fact-done 6))
; (stack (fact-done 6))
; (stack ())
;
; Fibonacci:
;
; (fib 4)
; (stack n=4 fib-done)                                     ; fib-loop
; (stack n=3 afterfib-n-1 n=4 fib-done)                    ; fib-loop
; (stack n=2 afterfib-n-1 n=3 afterfib-n-1 n=4 fib-done)   ; fib-loop
; (stack val=1 afterfib-n-1 n=3 afterfib-n-1 n=4 fib-done) ; afterfib-n-1
; (stack n=3 afterfib-n-1 n=4 fib-done)                    ; afterfib-n-2
; (stack val=1 afterfib-n-1 n=4 fib-done)                  ; afterfib-n-1
; (stack n=4 fib-done)                                     ; afterfib-n-2
; (stack val=2 fib-done)                                   ; afterfib-n-1
; (stack n=2 afterfib-n-2 val=2 fib-done)                  ; fib-loop
; (stack val=1 afterfib-n-2 val=2 fib-done)                ; afterfib-n-1
; (stack val=2 fib-done)                                   ; afterfib-n-2
; (stack)                                                  ; afterfib-n-2
