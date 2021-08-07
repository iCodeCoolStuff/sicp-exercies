(load "parallel.scm")

(define x 10)
(define s (make-serializer))
(define (test)
(parallel-execute
  (lambda () (set! x ((s (lambda () (* x x))))))
  (s (lambda () (set! x (+ x 1))))))

; 121
; 101
; 100
; 110 is eliminated because x access in (lambda ()_ (* x x)) is serialized
; 11 is eliminated because (lambda () (set! x (+ x 1))) is serialized
