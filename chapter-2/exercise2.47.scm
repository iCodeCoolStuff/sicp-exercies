(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

; ----------------------------------
; Implementation 1

(define (origin frame)
  (car frame))

(define (edge1 frame)
  (cadr frame))

(define (edge2 frame)
  (cadr (cdr frame)))

; ----------------------------------
; Implementation 2

(define (origin frame)
  (car frame))

(define (edge1 frame)
  (cadr frame))

(define (edge2 frame)
  (cdr (cdr frame)))
