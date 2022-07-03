(define fib-machine
 (make-machine
  '(n val continue)
  (list (list '< <) (list '+ +) (list '- -))
  '(start
     (assign continue (label fib-done))
   fib-loop
     (test (op <) (reg n) (const 2))
     (branch (label immediate-answer))
     ;; set up to compute Fib(n - 1)
     (save continue)
     (assign continue (label afterfib-n-1))
     (save n)                           ; save old value of n
     (assign n (op -) (reg n) (const 1)); clobber n to n - 1
     (goto (label fib-loop))            ; perform recursive call
   afterfib-n-1                         ; upon return, val contains Fib(n - 1)
     (restore n)
     (restore continue)
     ;; set up to compute Fib(n - 2)
     (save continue)
     (assign n (op -) (reg n) (const 2))
     (assign continue (label afterfib-n-2))
     (save val)                         ; save Fib(n - 1)
     (goto (label fib-loop))
   afterfib-n-2                         ; upon return, val contains Fib(n - 2)
     (assign n (reg val))
     (restore val)
     (restore continue)
     (assign val                        ;  Fib(n - 1) +  Fib(n - 2)
             (op +) (reg val) (reg n)) 
     (goto (reg continue))              ; return to caller, answer is in val
   immediate-answer
     (assign val (reg n))               ; base case:  Fib(n) = n
     (goto (reg continue))
   fib-done)))

(set-register-contents! fib-machine 'n 10)
(start fib-machine)
(newline)(display (get-register-contents fib-machine 'val))

; a)

; afterfib-n-2          
;   (assign n (reg val))
;   (restore val);

; -->

;  afterfib-n-2         
;    (restore n)        

; b)

(define (make-stack)
  (let ((s '()))
    (define (push x name)
      (set! s (cons (cons name x) s)))
    (define (pop name)
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (car s)))
            (if (not (eq? (car top) name))
                (error "Trying to pop stack with different name than previously" name (car top))
                (begin
                  (set! s (cdr s))
                  (cdr top))))))
    (define (initialize)
      (set! s '())
      'done)
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) pop)
            ((eq? message 'initialize) (initialize))
            (else (error "Unknown request -- STACK"
                         message))))
    dispatch))


(define (pop stack name)
  ((stack 'pop) name))

(define (push stack value name)
  ((stack 'push) value name))

(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (push stack (get-contents reg) (stack-inst-reg-name inst))
      (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (set-contents! reg (pop stack (stack-inst-reg-name inst)))    
      (advance-pc pc))))
; c)

(define (make-stack)
  (let ((s '()))
    (define (push x name)
      (set! s (cons (cons name x) s)))
    (define (pop name)
      (define (remove x s)
        (cond ((null? s) s)
              ((equal? (car s) x) (cdr s))
              (else (cons (car s) (remove x (cdr s))))))
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (assoc name s)))
            (if (not top)
                (error "no item with name in stack:" name)
                (begin
                  (set! s (remove top s))
                  (cdr top))))))
    (define (initialize)
      (set! s '())
      'done)
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) pop)
            ((eq? message 'initialize) (initialize))
            (else (error "Unknown request -- STACK"
                         message))))
    dispatch))

(define (pop stack name)
  ((stack 'pop) name))

(define (push stack value name)
  ((stack 'push) value name))


; Same as above 
(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (push stack (get-contents reg) (stack-inst-reg-name inst))
      (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (set-contents! reg (pop stack (stack-inst-reg-name inst)))    
      (advance-pc pc))))
