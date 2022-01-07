; Mr. Moore; Mr. Hall
; Colonel Downing
; Sir Barnacle Hood
; Dr. Parker

; Mr. Moore         - Lorna
; Mr. Hall          - Rosalind
; Colonel Downing   - Melissa
; Sir Barnacle Hood - Gabrielle
; Dr. Parker        -


; Steps:
; ---------------
; Represent the problem in terms of data
; ... (selectors)
; define constraints

; so how do we represent the ownership of each father's daughter?
; mapped pairs
; a - 1
; b - 2
; c - 3
; d - 4
; e - 5

; how do we represent the ownership of a yacht named after x's daughter?

; a (y 5) 3

; dad, yacht named after daughter, actual daughter dad owns

; Mr. Moore         - a
; Mr. Hall          - b
; Colonel Downing   - c
; Sir Barnacle Hood - d
; Dr. Parker        - e

; Lorna     - 1
; Rosalind  - 2
; Melissa   - 3
; Gabrielle - 4
; Dr. Parker's daughter - 5


; Syntax:

; /- -> does not own [daughter]
; => -> owns [daughter]
; -+ owns yacht named by [daughter]
 
; Constraints:
; a /- 1
; b /- 2
; c /- 3
; d /- 4

; d => 3
; c -+ 3
; c /- 3

; ? -+ 5
; ? => 4

; a (y 1) 5
; b (y 2) 4
; c (y 3) 2
; d (y 4) 3
; e (y 5) 1

; (list 'a (list 'y 1) 5)


;(define (lornas-father)
  ;(let ((lorna 1)
        ;(rosalind 2)
        ;(melissa 3)
        ;(gabrielle 4)
        ;(mary-ann 5))
    ;(let ((moore   (list 'a (list 'y (amb lorna rosalind melissa gabrielle mary-ann))
                                     ;(amb lorna rosalind melissa gabrielle mary-ann)))
          ;(hall    (list 'b (list 'y (amb lorna rosalind melissa gabrielle mary-ann))
                                     ;(amb lorna rosalind melissa gabrielle mary-ann)))
          ;(downing (list 'c (list 'y (amb lorna rosalind melissa gabrielle mary-ann))
                                     ;(amb lorna rosalind melissa gabrielle mary-ann)))
          ;(hood    (list 'd (list 'y (amb lorna rosalind melissa gabrielle mary-ann))
                                     ;(amb lorna rosalind melissa gabrielle mary-ann)))
          ;(dr-p    (list 'e (list 'y (amb lorna rosalind melissa gabrielle mary-ann))
                                     ;(amb lorna rosalind melissa gabrielle mary-ann)))
          ;(yacht-daughter-name (lambda (d) (cadadr d)))
          ;(own-daughter-name   (lambda (d) (caddr d))))
    ;(let ((dads (list moore hall downing hood dr-p)))
      ;(display dads)(newline)
      ;(require (and (distinct? (map yacht-daughter-name dads))
                    ;(distinct? (map own-daughter-name dads))))
      ;(require (not (= (own-daughter-name moore) lorna)))
      ;(require (not (= (own-daughter-name hall) rosalind)))
      ;(require (not (= (own-daughter-name downing) melissa)))
      ;(require (not (= (own-daughter-name hood) gabrielle)))
      ;(require (= (own-daughter-name hood) melissa))
      ;(require (= (yacht-daughter-name downing) melissa))
      ;(require (not (= (own-daughter-name downing) melissa)))
      ;(require (member true (map (lambda (d) (and (= (yacht-daughter-name d) mary-ann))
                                                ;(= (own-daughter-name gabrielle))) dads)))
      ;dads))))

;(define (lornas-father)
;  (let ((lorna 1)
;        (rosalind 2)
;        (melissa 3)
;        (gabrielle 4)
;        (mary-ann 5)
;        (yacht-daughter-name (lambda (d) (cadadr d)))
;        (own-daughter-name   (lambda (d) (caddr d))))
;    (let ((moore   (list 'a (list 'y (amb lorna rosalind melissa gabrielle mary-ann))
;                                     (amb lorna rosalind melissa gabrielle mary-ann))))
;      (require (= (own-daughter-name moore) mary-ann))
;      (require (= (yacht-daughter-name moore) lorna))
;      (let ((hall (list 'b (list 'y (amb lorna rosalind melissa gabrielle mary-ann))
;                                    (amb lorna rosalind melissa gabrielle mary-ann))))
;        (require (not (= (own-daughter-name hall) rosalind)))
;        (require (not (= (own-daughter-name hall) (yacht-daughter-name hall))))
;        (let ((downing (list 'c (list 'y (amb lorna rosalind melissa gabrielle mary-ann))
;                                        (amb lorna rosalind melissa gabrielle mary-ann))))
;          (require (= (yacht-daughter-name downing) melissa))
;          (require (not (= (own-daughter-name downing) melissa)))
;          (let ((hood (list 'd (list 'y (amb lorna rosalind melissa gabrielle mary-ann))
;                                        (amb lorna rosalind melissa gabrielle mary-ann))))
;            (require (not (= (own-daughter-name hood) gabrielle)))
;            (require (= (own-daughter-name hood) melissa))
;            (let ((dr-p    (list 'e (list 'y (amb lorna rosalind melissa gabrielle mary-ann))
;                                             (amb lorna rosalind melissa gabrielle mary-ann))))
;              (require (not (= (own-daughter-name dr-p) (yacht-daughter-name dr-p))))
;              (require (= (yacht-daughter-name dr-p) mary-ann))
;              (let ((dads (list moore hall downing hood dr-p)))
;                (display dads)(newline)
;                (require (and (distinct? (map yacht-daughter-name dads))
;                              (distinct? (map own-daughter-name dads))))
;                (require (member true (map (lambda (d) (and (= (yacht-daughter-name d) (own-daughter-name dr-p))
;                                                            (= (own-daughter-name d) gabrielle))) dads)))
;      dads))))))))
;
;
;(define (lornas-father)
;  (let ((lorna 'lorna)
;        (rosalind 'rosalind)
;        (gabrielle 'gabrielle)
;        (melissa 'melissa)
;        (mary-ann 'mary-ann)
;        (daughter (lambda (dad) (caddr dad)))
;        (yacht    (lambda (dad) (cadadr dad))))
;    (let ((owns         (lambda (dad y) (eq? (yacht dad) y)))
;          (has-daughter (lambda (dad d) (eq? (daughter dad) d))))
;      (let ((father-of  (lambda (d dads) (car (filter (lambda (dad) (has-daughter dad d)) dads)))))
;        (let ((moore (list 'moore (list 'yacht (amb lorna rosalind melissa gabrielle mary-ann))
;                                               (amb lorna rosalind melissa gabrielle mary-ann))))
;          (require (owns moore lorna))
;          (require (has-daughter moore mary-ann))
;          (let ((hall (list 'hall (list 'yacht (amb lorna rosalind melissa gabrielle mary-ann))
;                                               (amb lorna rosalind melissa gabrielle mary-ann))))
;            (require (owns hall rosalind))
;            (let ((downing (list 'downing (list 'yacht (amb lorna rosalind melissa gabrielle mary-ann))
;                                                       (amb lorna rosalind melissa gabrielle mary-ann))))
;              (require (owns downing melissa))
;              (let ((hood (list 'hood (list 'yacht (amb lorna rosalind melissa gabrielle mary-ann))
;                                                   (amb lorna rosalind melissa gabrielle mary-ann))))
;                (require (owns hood gabrielle))
;                (require (has-daughter hood melissa))
;                (let ((dr-p (list 'dr-p (list 'yacht (amb lorna rosalind melissa gabrielle mary-ann))
;                                                     (amb lorna rosalind melissa gabrielle mary-ann))))
;                  (require (owns dr-p mary-ann))
;                  (let ((dads (list moore hall downing hood dr-p)))
;                    (require (all (map (lambda (dad) (not (eq? (daughter dad) (yacht dad)))) dads)))
;                    (require (and (distinct? (map yacht dads)) (distinct? (map daughter dads))))
;                    (require (owns (father-of gabrielle dads) (daughter dr-p)))
;                    dads))))))))))

;
;
;

(define (map proc seq)
  (if (null? seq)
      '()
      (cons (proc (car seq)) (map proc (cdr seq)))))

(define (filter pred seq)
  (cond ((null? seq) '())
        ((pred (car seq)) (cons (car seq) (filter pred (cdr seq))))
        (else (filter pred (cdr seq)))))

(define (all seq)
  (cond ((null? seq) true)
        ((false? (car seq)) false)
        (else (all (cdr seq)))))

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (lornas-father)
  (let ((lorna 'lorna)
        (rosalind 'rosalind)
        (gabrielle 'gabrielle)
        (melissa 'melissa)
        (mary-ann 'mary-ann))
    (let ((make-dad (lambda (name yacht-name daughter-name) (list name (list 'yacht yacht-name) daughter-name)))
          (a-potential-daughter (lambda () (amb lorna rosalind gabrielle melissa mary-ann)))
          (daughter (lambda (dad) (caddr dad)))
          (yacht    (lambda (dad) (cadadr dad))))
      (let ((owns         (lambda (dad y) (eq? (yacht dad) y)))
            (has-daughter (lambda (dad d) (eq? (daughter dad) d))))
        (let ((father-of  (lambda (d dads) (car (filter (lambda (dad) (has-daughter dad d)) dads)))))
          (let ((moore (make-dad 'moore (a-potential-daughter) (a-potential-daughter))))
            (require (owns moore lorna))
            (require (has-daughter moore mary-ann))
            (let ((hall (make-dad 'hall (a-potential-daughter) (a-potential-daughter))))
              (require (owns hall rosalind))
              (let ((downing (make-dad 'downing (a-potential-daughter) (a-potential-daughter))))
                (require (owns downing melissa))
                (let ((hood (make-dad 'hood (a-potential-daughter) (a-potential-daughter))))
                  (require (owns hood gabrielle))
                  (require (has-daughter hood melissa))
                  (let ((dr-p (make-dad 'dr-p (a-potential-daughter) (a-potential-daughter))))
                    (require (owns dr-p mary-ann))
                    (let ((dads (list moore hall downing hood dr-p)))
                      (require (all (map (lambda (dad) (not (eq? (daughter dad) (yacht dad)))) dads)))
                      (require (and (distinct? (map yacht dads)) (distinct? (map daughter dads))))
                      (require (owns (father-of gabrielle dads) (daughter dr-p)))
                      dads)))))))))))

; Lorna's father is Colonel Downing
; There are 2 solutions if we are not told that Mary Ann's father is Moore.
