(define (loop? exp) (tagged-list? exp 'loop))
(define (loop-condition exp) (cadr exp))
(define (loop-body exp) (caddr exp))
(define (loop-return exp) (cadddr exp))

(define (make-loop condition body return)
  (list condition body return))
(define (make-definition var value)
  (list var value))

(define (eval-loop exp env)
  (if (eval (loop-condition exp) env)
      (begin (eval (loop-body exp) env)
	     (eval-loop exp))
      (loop-return exp)))

(define (while? exp) (tagged-list? exp 'while))
(define (while-condition exp) (cadr exp))
(define (while-body exp) (caddr exp))
(define (make-while condition body)
  (list 'while condition body))

(define (while->loop exp)
  (make-loop (while-condition exp) (while-body exp) '()))

(define (make-not exp) (list 'not exp))
(define (not-contents not-exp) (cadr exp))
(define (eval-not exp env)
  (if (eq? (eval (not-contents exp) env) 'false)
      'true
      'false))

(define (until? exp) (tagged-list? exp 'until))
(define (until-condition exp) (cadr exp))
(define (until-body exp) (caddr exp))
(define (make-until condition body)
  (list 'until condition body))
(define (until->loop exp)
  (make-loop (make-not (until-condition exp)) (until-body exp) '()))

(define (make-let-clause var exp))
(define (make-let clauses body)
  (list 'let clauses body))
(define (for-var exp) (cadr exp))
(define (for-list exp) (cadddr exp))
(define (for-body exp) (fourth exp))
(define (for? exp)
  (and
    (tagged-list? exp 'for)
    (symbol? (for-var exp))
    (eq? (caddr exp) 'in)
    (list? (for-list exp))))

(define (make-for variable lst body)
  (list 'for variable 'in lst body))
(define (for->let exp)
  (expand-for (for-var exp) (for-list exp) (for-body exp)))

(define (expand-for var lst body)
  (if (null? lst)
      '()
      (make-let (list (make-let-clause var (car lst)))
		(make-begin 
		  (list body (expand-for var (cdr lst) body))))))

;(define (do? exp) (tagged-list? exp 'do))
;(define (do-bindings exp) (cadr exp))
;(define (variable-bindings exp) (map (lambda (b) (list (car b) (cadr b))) (do-bindings exp)))
;(define (do-steps exp) (map cddr (do-bindings exp)))
;(define (do-test exp) (caddr exp))
;(define (do-return exp) (cdaddr exp))
;(define (do-body exp) (cadddr exp))

;(define (do->let->loop exp)
  ;(make-let (variable-bindings exp)
	    ;(make-loop (do-test exp)
		       ;(make-begin (list (do-body exp)
			                 ;(do-steps exp))) ; can't implement without set!
		       ;(do-return exp))))


; Iteration constructs: loop, while, until, for, do (omitted for reasons explained later).
;
; Loop is the base iteration construct used to make all other iteration constructs (except for). 
; Technically, loop can be represented by a procedure or named let, but that would require 
; the use of make-procedure which would couple loops with how procedures are created (i.e. requires
; loop to take env as a parameter).That is a bad design choice, so I decided to make loop a 
; special form that has its own evaluation rules.
;
; Loop has 3 arguments: a condition that will break the loop if met, the body of the loop statement,
; and a return value. It isn't meant to be used on its own, but it definitely can be.
;
; Usage:
; 
; (define x 0)
; (loop (< x 11)
;   (begin (newline)
;          (display x)
;          (set! x (+ x 1)))
;   x)
; 
; While is a more practical looping statement. It only has two arguments: A condition and a body.
; While has no return statement, so it is equivalent to (loop condition body '())
; 
; Usage:
; 
; (define x 0)
; (while (<= x 10)
;   (newline)
;   (display x)
;   (set! x (+ x 1)))
;
; Until works the same as while except the loop terminates when the condition is false. Until
; is syntactic sugar for (while (not condition) body)
;
; Usage:
; (define x 0)
; (define (fib n)
;   (cond ((= n 0) 0)
;         ((= n 1) 1)
;         (else (+ (fib (- n 1) (- n 2))))))
;
; (until (= x 10)
;   (newline)
;   (display (fib x))
;   (set! x (+ x 1)))
;
; For is your typical for loop.
;
; Usage:
;
; (for i in (enumerate-interval 0 10)
;  (newline)
;  (display (square i)))
;
; Do is useful for functional programming (https://groups.csail.mit.edu/mac/ftpdir/scheme-mail/HTML/rrrs-1986/msg00300.html).
; However, I couldn't implement it here because it requires the use of set! which is beyond the scope of this exercise.

; Do is the form (do ((variable init step) ...) (test expression ...) command ...)
;
; Usage:
;
; (do ((i 0 (+ i 1)))
;   ((= i 10) 'hooray!)
;   (newline) (display (square i)))
