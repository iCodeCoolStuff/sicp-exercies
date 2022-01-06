; figure out how to represent our problem
; represent and generate a set of floor possibilities
; eliminate possibilities that do not satisfy constraints
; return answer

; each floor = number
; why?

; floors are ordinal and numbers are ordinal
; we can compare ordinals to see which numbers are before, after, equal, etc.

; what can a set of floor possibilites be?


; Generate a set of floor possibilities
; verify if the set of floor possibilities is possible
; generate next set of possibilities
; repeat until the final possibility has been found

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

(define (remove seq x)
  (if (= (car seq) x)
    (cdr seq)
    (cons (car seq) (remove (cdr seq) x))))

(define (permutations s)
  (if (null? s)
    (list `())
    (flatmap (lambda (x)
	       (map (lambda (p) (cons x p))
		    (permutations (remove s x))))
	     s)))

(define (multiple-dwelling)
  (let ((apartment (list 1 2 3 4 5))
        (baker (lambda (a) (first a)))
        (cooper (lambda (a) (second a)))
        (fletcher (lambda (a) (third a)))
        (miller (lambda (a) (fourth a)))
        (smith (lambda (a) (fifth a))))
    (let ((perms (permutations apartment)))
      (define (loop lst)
        (let ((l (car lst)))
          (if (and 
                (not (= (baker l) 5))
                (not (= (cooper l) 1))
                (and (not (= (fletcher l) 5)) (not (= (fletcher l) 1)))
                (> (miller l) (cooper l))
                (not (= (abs (- (smith l) (fletcher l))) 1))
                (not (= (abs (- (fletcher l) (cooper l))) 1)))
              (list (list 'baker (baker l))
                    (list 'cooper (cooper l))
                    (list 'fletcher (fletcher l))
                    (list 'miller (miller l))
                    (list 'smith (smith l)))
              (loop (cdr lst)))))
       (loop perms))))
