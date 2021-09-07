(define (loop? exp) (tagged-list? exp 'loop))
(define (loop-condition exp) (cadr exp))
(define (loop-body exp) (caddr exp))
(define (loop-return exp) (cadddr exp))

(define (make-loop condition body return)
  (list 'loop condition body return))

(define (make-definition def-variable def-parameters def-body)
  (list 'define def-variable (make-lambda def-parameters def-body)))

(define (loop->application exp)
  (sequence->exp
    (list (make-definition 'loop-inner '() 
			  (list (make-if (loop-condition exp)
			      	                     (sequence->exp
						       (list (loop-body exp) 
						       '(loop-inner)))
				                     (loop-return exp))))
	  '(loop-inner))))

(define (eval-loop exp env)
  (eval (loop->application exp) env))

(define (while? exp) (tagged-list? exp 'while))
(define (while-condition exp) (cadr exp))
(define (while-body exp) (cddr exp))
(define (make-while condition body)
  (list 'while condition body))

(define (while->loop exp)
  (make-loop (while-condition exp) (sequence->exp (while-body exp)) ''done))

(define (make-not exp) (list 'not exp))
(define (not-contents exp) (cadr exp))
(define (eval-not exp env)
  (if (true? (eval (not-contents exp) env))
      false
      true))

(define (not? exp) (tagged-list? exp 'not))
(define (until? exp) (tagged-list? exp 'until))
(define (until-condition exp) (cadr exp))
(define (until-body exp) (cddr exp))
(define (make-until condition body)
  (list 'until condition body))
(define (until->loop exp)
  (make-loop (make-not (until-condition exp)) (sequence->exp (until-body exp)) ''done))

(define (make-let-clause var exp) (list var exp))
(define (make-let clauses body)
  (list 'let clauses body))
(define (for-var exp) (cadr exp))
(define (for-list exp) (cadddr exp))
(define (for-body exp) (cddddr exp))
(define (for? exp) (tagged-list? exp 'for))

(define (make-for variable lst body)
  (list 'for variable 'in lst body))

(define (eval-for exp env)
  (let ((f-list (eval (for-list exp) env)))
    (eval (expand-for (for-var exp) f-list (sequence->exp (for-body exp))) env)))

(define (expand-for var lst body)
  (if (null? lst)
      ''done
      (make-let (list (make-let-clause var (car lst)))
		(list body (expand-for var (cdr lst) body)))))

(define (do? exp) (tagged-list? exp 'do))
(define (do-bindings exp) (cadr exp))
(define (variable-bindings exp) (map (lambda (b) (list (car b) (cadr b))) (do-bindings exp)))
(define (do-variables exp) (map car (do-bindings exp)))
(define (do-inits exp) (map cadr (do-bindings exp)))
(define (do-steps exp) (map caddr (do-bindings exp)))
(define (do-test exp) (caaddr exp))
(define (do-return exp) (cdaddr exp))
(define (do-body exp) (cdddr exp))

(define (do->let->exp exp)
  (sequence->exp
    (list (make-definition 'do-inner
          (do-variables exp) (list (make-if (do-test exp)
				      (sequence->exp (do-return exp))
				      (sequence->exp (list (sequence->exp (do-body exp))
					                   (cons 'do-inner (do-steps exp)))))))
	  (cons 'do-inner (do-inits exp)))))

; Iteration constructs: loop, while, until, for, do.
;
; Loop is a base iteration construct used to make other iteration constructs like while and until.
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
; For is your typical for loop. It requires a symbol and a list of items to iterate over.
;
; Usage:
;
; (for i in (enumerate-interval 0 10)
;  (newline)
;  (display (square i)))
;
; Do is useful for functional programming (https://groups.csail.mit.edu/mac/ftpdir/scheme-mail/HTML/rrrs-1986/msg00300.html).
; Do is the form (do ((variable init step) ...) (test expression ...) command ...)
;
; Usage:
;
; (do ((i 0 (+ i 1)))
;   ((= i 10) 'hooray!)
;   (newline) (display (square i)))
