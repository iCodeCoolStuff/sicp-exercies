(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
	right
	(append (symbols left) (symbols right))
	(+ (weight left) (weight right))))

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
	
(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree
                   (make-leaf 'B 2)
                   (make-code-tree (make-leaf 'D 1)
                                   (make-leaf 'C 1)))))

(define (test)
  (encode-symbol 'B sample-tree))
