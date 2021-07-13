(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
	 (count-pairs (cdr x))
	 1)))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

; Will not return at all
; (count-pairs (make-cycle (list 'a 'b 'c)))

(define (test)
  (define z (make-cycle (list 'a 'b 'c)))
  (last-pair z))


(define x (cons 'a 'b))
(define y (cons x '5))
(define z (cons x y))

(define a (cons 'c 'c))
(define b (cons a a))
(define c (cons b b))

; counts 3
;
; [o][o]-->[o][o]
;  |        |  |
;  |        |  |
;  |        V  V
;  V       'a 'b
; [o][o]
;  |  |
;  |  |
;  V  V
; 'c 'd
;
; counts 4
;
; [o][o]---------------+
;  |                   |
;  |                   |
;  V                   V
; [o][o]<------------[o][o]
;  |  |                  |
;  V  V                  V
; 'a 'b                 'c
;
; counts 7
;
; [o][o]
;  |  |
;  V  V
; [o][o]
;  |  |
;  V  V
; [o][o]
;  |  |
;  V  V
; 'a 'b
;
; never ends
;
;  +->[o][o]---->[o][o]
;  |   |             |
;  |  'a             |
;  +-----------------+
