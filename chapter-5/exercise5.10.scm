(define (register-exp? exp) (symbol? exp))
(define (register-exp-reg exp) exp)
(define (constant-exp? exp) (number? exp))
(define (constant-exp-value exp) exp)
(define (label-exp? exp) (and (pair? exp) (= (length exp) 1) (symbol? (car exp))))
(define (label-exp-label exp) (car exp))

(define (operation-exp? exp)
  (and (pair? exp) (pair? (car exp))))
(define (operation-exp-op operation-exp)
  (caar operation-exp))
(define (operation-exp-operands operation-exp)
  (cdar operation-exp))
  
(define gcd-machine
  (make-machine
   '(a b t)
   (list (list 'rem remainder) (list '= =))
   '(test-b
       (test (= b 0))
       (branch (gcd-done))
       (assign t (rem a b))
       (assign a b)
       (assign b t)
       (goto (test-b))
     gcd-done)))

(set-register-contents! gcd-machine 'a 206)
(set-register-contents! gcd-machine 'b 40)
(start gcd-machine)
(get-register-contents gcd-machine 'a) ; 2
