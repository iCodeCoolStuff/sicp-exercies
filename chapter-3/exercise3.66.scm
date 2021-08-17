(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))

(define (pairs s t)
  (cons-stream 
    (list (stream-car s) (stream-car t))
    (interleave
      (stream-map (lambda (x) (list (stream-car s) x))
		  (stream-cdr t))
      (pairs (stream-cdr s) (stream-cdr t)))))

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
		   (interleave s2 (stream-cdr s1)))))

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))

(define (display-line x) (newline) (display x))
(define (display-stream s)
  (stream-for-each display-line s))

(define (test)
  (define s (pairs integers integers))
  (define (stream-iter s)
    (if (not (and (= (car (stream-car s)) 1) (= (cadr (stream-car s)) 100)))
	(begin (display-line (stream-car s))
	       (stream-iter (stream-cdr s)))))
  (stream-iter s))

; The order in which the pairs are placed alternates from the first stream to the second back to the first then to the alternate
; of the second stream

; So it would go like: 1->2-1->3->1->2->1->4->1->2->1->3->1->2->1->4->1->2->1->3->1->2->1->5 ...

; (Each stream refers to the stream of pairs that starts with that number. 1 would be {(1 1), (1 2), ...}. 2 would be 
; {(2 2), (2 3), ...}. 3 would be {(3 3), (3 4), ...}. etc.)

; The number of pairs that are in between each occurence of a pair that starts with the number n is 2^n - 1. So there is 1
; pair in between each instance of (1, m), 3 pairs in between each instance of (2, m), etc. It would be 99 (there are two pairs of
; one at the beginning) pairs before (1, 100), (2^99-1) * 100 pairs before (99, 100), and (2^100 - 1) * 100 pairs before (100, 100).
