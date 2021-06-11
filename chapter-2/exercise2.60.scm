(define (element-of-set? x set)
  (memq x set))

(define (adjoin-set x set)
  (cons x set))

(define (union-set set1 set2)
  (append set1 set2))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)
	 (cons (car set1) (intersection-set (cdr set1) set2)))
	(else (intersection-set (cdr set1) set2))))

; Efficiency: adjoin-set runs in O(1). element-of-set? has the same efficiency as before. union-set runs in O(n) time
; (append procedure runs in O(n) time). intersection-set runs the same as before (O(n*m)).

; Applications: Finding the union of two sets is preferable in this representation.
