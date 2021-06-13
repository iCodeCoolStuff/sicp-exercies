; a

; First, the program allocates (n-1)/2 elements to the left part of the tree. The program constructs the left result from the
; allocated space and fetches the left tree. The right size is allocated from the size (n - (left-size + 1)). 
; The current entry from the tree is fetched from the non-left elements. The right result is constructed from the right size 
; and non-left elements. The right tree is retrieved from the right result. Fianally, the tree is 
; constructed from the left tree, the right tree, and the current entry.

; b
; (5 (1 () (3 () ())) (9 (7 () ()) (11 () ()))) 
; The order of growth is Theta(n).
;
;       5
;      / \
;     /   \
;    1     9
;     \   / \
;      3 /   \
;       /     \
;      7       11
;

(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts)
                                              right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree)
                      remaining-elts))))))))

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))
