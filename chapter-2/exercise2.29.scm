(define (make-mobile left right)
  (list left right))

(define left-branch car)
(define (right-branch m) (car (cdr m)))

(define (make-branch length structure)
  (list length structure))

(define branch-length car)
(define (branch-structure b) (car (cdr b)))

(define (total branch)
  (if (number? (branch-structure branch)) (branch-structure branch) (total-weight branch)))

(define (total-weight mobile)
  (+ (total (left-branch mobile)) (total (right-branch mobile))))
	
(define (partb)
  (define mobile (list (list 1 2) (list 3 4)))
  (total-weight mobile))

(define (balanced? mobile)
  (= (total (left-branch mobile)) (total (right-branch mobile))))

(define (partc)
  (define mobile (list (list 1 2) (list 3 4)))
  (display (balanced? mobile))
  (define mobile2 (list (list 1 5) (list 3 5)))
  (display (balanced? mobile2)))

; Part d
; I would have to change right branch to:
; (define right-branch cdr)

; and branch-structure to:
; (define branch-structure cdr)
