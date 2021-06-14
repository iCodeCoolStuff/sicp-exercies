(define (generate-huffmann-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)    ; symbol
                               (cadr pair))  ; frequency
                    (make-leaf-set (cdr pairs))))))

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))
(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))
(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))

(define (successive-merge leaf-set)
  (if (= (length leaf-set) 1)
      (car leaf-set)
      (let ((rest (cddr leaf-set))
	    (node (make-code-tree (car leaf-set) (cadr leaf-set))))
	   (successive-merge (adjoin-set node rest)))))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
	'()
	(let ((next-branch
	       (choose-branch (car bits) current-branch)))
	  (if (leaf? next-branch)
	      (cons (symbol-leaf next-branch)
		    (decode-1 (cdr bits) tree))
	      (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
	(else (error "bad bit -- CHOOSE-BRANCH" bit))))

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
	      (encode (cdr message) tree))))

(define (encode-symbol symbol tree)
  (if (symbol-in? symbol tree)
      (find-symbol symbol tree)
      (error "symbol not found -- ENCODE-Symbol" symbol tree)))

(define (adjoin-bits b bits)
  (if (null? bits)
      (cons b bits)
      (cons (car bits) (adjoin-bits b (cdr bits)))))

(define (symbol-in? symbol tree)
  (memq symbol (symbols tree)))

(define (find-symbol s tree)
  (define (find-iter branch bits)
    (cond ((leaf? branch) (if (eq? (symbol-leaf branch) s) 
			      bits 
			      '()))
          ((symbol-in? s tree) (append (find-iter (left-branch branch) (adjoin-bits '0 bits))
				       (find-iter (right-branch branch) (adjoin-bits '1 bits))))
	  (else '())))
  (find-iter tree ()))

(define (test)
  (generate-huffmann-tree
    (list
      (list 'A 2)
      (list 'BOOM 1)
      (list 'GET 2)
      (list 'JOB 2)
      (list 'NA 16)
      (list 'SHA 3)
      (list 'YIP 9)
      (list 'WAH 1))))

; Encoded messages:
;(1 1 1 1 1 1 1 0 0 1 1 1 1 0) 14
;(1 1 1 0 0 0 0 0 0 0 0 0)     12
;(1 1 1 1 1 1 1 0 0 1 1 1 1 0) 14
;(1 1 1 0 0 0 0 0 0 0 0 0)     12
;(1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0) 23
;(1 1 1 0 1 1 0 1 1) 9

;Using huffmann encoding: 84 bits


;If using a fixed-bit encoding:
;4 bits (8 states) * 84 = 336 bits
