(define empty-board ())

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
	(list empty-board)
	(filter
	  (lambda (positions) (safe? k positions))
	    (flatmap
	      (lambda (rest-of-queens)
		(map (lambda (new-row)
		       (adjoin-position
			 new-row k rest-of-queens))
		     (enumerate-interval 1 board-size)))
	      (queen-cols (- k 1))))))
  (queen-cols board-size))

(define (flatmap proc seq)
  (accumulate append () (map proc seq)))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
	  (accumulate op initial (cdr sequence)))))

(define (enumerate-interval low high)
  (if (> low high)
      ()
      (cons low (enumerate-interval (+ low 1) high))))

(define (filter predicate sequence)
  (cond ((null? sequence) ())
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (adjoin-position new-row k rest-of-queens)
  (cons (cons new-row k) rest-of-queens))

(define (safe? k positions)
  (let ((queen (car positions))
	(rest  (cdr positions)))
    (cond ((not (null? (filter (lambda (position) (= (car position) (car queen))) rest))) #f)
          ((not (null? (filter (lambda (position) (= (- (car queen) (car position)) (- k (cdr position)))) rest))) #f) ;diag up
          ((not (null? (filter (lambda (position) (= (- (car position) (car queen)) (- k (cdr position)))) rest))) #f) ;diag down
	  (else #t))))

(define (test)
  (for-each (lambda (x) (display x)(newline)) (queens 8)))
