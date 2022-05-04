(define (an-integer-between a b)
  (require (<= a b))
  (amb a (an-integer-between (+ a 1) b)))

(define (adjoin-position new-row k rest-of-queens)
 (cons (cons new-row k) rest-of-queens))

(define (map func lst)
 (if (null? lst)
     '()
     (cons (func (car lst)) (map func (cdr lst)))))

(define (filter pred lst)
 (cond ((null? lst) '())
       ((pred (car lst)) (cons (car lst) (filter pred (cdr lst))))
       (else (filter pred (cdr lst)))))

(define (safe? k positions)
  (let ((queen (car positions))
	(rest  (cdr positions)))
    (cond ((not (null? (filter (lambda (position) (= (car position) (car queen))) rest))) false)
          ((not (null? (filter (lambda (position) (= (- (car queen) (car position)) (- k (cdr position)))) rest))) false)
          ((not (null? (filter (lambda (position) (= (- (car position) (car queen)) (- k (cdr position)))) rest))) false)
	  (else true))))

(define (flatmap proc lst)
 (if (null? lst)
     lst
     (append (map proc (car lst)) (flatmap proc (cdr lst)))))

(define (queens board-size)
 (define empty-board (list))
 (define (queen-cols k)
  (if (= k 0)
      empty-board
      (let ((new-row (an-integer-between 1 board-size)))
       (let ((positions (adjoin-position new-row k (queen-cols (- k 1)))))
        (require (safe? k positions))
        positions))))
 (queen-cols board-size))
