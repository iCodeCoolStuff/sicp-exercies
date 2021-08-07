(load "parallel.scm")

(define x 10)
(define s (make-serializer))
(define (test)
(parallel-execute
  (lambda () (set! x ((s (lambda () (* x x))))))
  (s (lambda () (set! x (+ x 1))))))

; 121
; 101
; 11
; 100
