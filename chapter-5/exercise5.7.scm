(define gcd-machine
  (make-machine
   '(a b t)
   (list (list 'rem remainder) (list '= =))
   '(test-b
       (test (op =) (reg b) (const 0))
       (branch (label gcd-done))
       (assign t (op rem) (reg a) (reg b))
       (assign a (reg b))
       (assign b (reg t))
       (goto (label test-b))
     gcd-done)))

(set-register-contents! gcd-machine 'a 206)
(set-register-contents! gcd-machine 'b 40)
(start gcd-machine)

(define expt-iter-machine
  (make-machine
   '(n b r1 r2 product counter)
   (list (list '* *) (list '+ +) (list '= =) (list '- -))
   '(expt-iter
      (test (op =) (reg n) (const 0))
      (branch (label expt-finished))
      (assign r1 (op *) (reg product) (reg b))
      (assign r2 (op +) (reg counter) (const 1))
      (assign n  (op -) (reg n) (const 1))
      (assign product (reg r1))
      (assign counter (reg r2))
      (goto (label expt-iter))
    expt-finished)))

(set-register-contents! expt-iter-machine 'n 8)
(set-register-contents! expt-iter-machine 'b 2)
(set-register-contents! expt-iter-machine 'product 1)
(set-register-contents! expt-iter-machine 'counter 1)
(start expt-iter-machine)
(get-register-contents expt-iter-machine 'product)

(define expt-rec-machine
  (make-machine
   '(n b val continue)
   (list (list '* *) (list '- -) (list '= =))
     '(start
       (assign continue (label expt-done))
     expt-loop
      (test (op =) (reg n) (const 0))
      (branch (label base-case))
      (save continue)
      (save n)
      (assign n (op -) (reg n) (const 1))
      (assign continue (label after-fact))
      (goto (label expt-loop))
    after-fact
      (restore n)
      (restore continue)
      (assign val (op *) (reg b) (reg val))
      (goto (reg continue))
    base-case
      (assign val (const 1))
      (goto (reg continue))
    expt-done)))

(set-register-contents! expt-rec-machine 'n 8)
(set-register-contents! expt-rec-machine 'b 2)
(start expt-rec-machine)
(get-register-contents expt-rec-machine 'val)
