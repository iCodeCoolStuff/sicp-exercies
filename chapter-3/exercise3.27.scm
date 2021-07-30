(define (make-table)
  (let ((local-table (list '*table*)))
    (define (make-record key value)
      (cons key value))
    (define (assoc key records)
      (cond ((null? records) false)
	    ((equal? key (caar records)) (car records))
	    (else (assoc key (cdr records)))))
    (define (insert! key value)
      (let ((records (cdr local-table)))
	(set-cdr! local-table (cons (cons key value) records))
	'ok))
    (define (lookup key)
      (let ((record (assoc key (cdr local-table))))
	(if record
	    (cdr record)
	    false)))
  (define (dispatch m)
    (cond ((eq? 'lookup-proc m) lookup)
          ((eq? 'insert-proc! m) insert!)
	  (else (error "Unknown operation: TABLE" m))))
  dispatch))

(define (memoize f)
  (let ((table (make-table)))
    (define get (table 'lookup-proc))
    (define put (table 'insert-proc!))
    (lambda (x)
      (let ((previously-computed-result
	      (get x)))
	(or previously-computed-result
	    (let ((result (f x)))
	      (put x result)
	      result))))))

(define memo-fib
  (memoize
    (lambda (n)
      (cond ((= n 0) 0)
            ((= n 1) 1)
	    (else (+ (memo-fib (- n 1)) (memo-fib (- n 2))))))))

; Environment Diagram: 
; 
;             +-------------+
; global env: | memo-fib:-+ |
;             +-----------|-+
;             E1:         V
; +------+    +-------------+
; |get:3 |--->| memo-fib: 3 |<---- +
; +------+    +-----------|-+      |
;             E3:         V        | E2:
; +------+    +-------------+    +-------------+   +------+
; |get:2 |--->| memo-fib: 2 |    | memo-fib: 1 |<--|get:1 |
; +------+    +-----------|-+    +-------------+   +------+
;             E4:         V
; +------+    +-------------+
; |get:1 |--->| memo-fib: 1 |
; +------+    +-------------+

; memo-fib computes the number of steps in proportion to n because the first recursive call in memo-fib always
; decreases by 1 which decreases with respect to n. The second call in memo-fib is already memoized,
; so the second call will always run in O(1) time. This results in an O(2n-1) runtie or O(n) runtime.

; The scheme would not work if we did (memoize fib) because the memoize function calls the unmemoized
; version of the fib function. This is why we need to define memo-fib in terms of itself.
