;;;;REGISTER-MACHINE SIMULATOR FROM SECTION 5.2 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch5.scm

;;;;This file can be loaded into Scheme as a whole.
;;;;Then you can define and simulate machines as shown in section 5.2

;;;**NB** there are two versions of make-stack below.
;;; Choose the monitored or unmonitored one by reordering them to put the
;;;  one you want last, or by commenting one of them out.
;;; Also, comment in/out the print-stack-statistics op in make-new-machine
;;; To find this stack code below, look for comments with **


(define (make-machine register-names ops controller-text)
  (let ((machine (make-new-machine)))
    ((machine 'install-operations) ops)
    ((machine 'install-instruction-sequence)
     (assemble controller-text machine))
    machine))

(define (is-assigned? inst-text)
  (eq? (car inst-text) 'assign))

(define (reg-names controller-text)
  (let ((instructions (extract-instructions controller-text)))
    (remove-duplicates (map (lambda (i) (cadr i))
         (filter is-assigned? instructions)))))

(define (extract-instructions controller-text)
  (cond ((null? controller-text) '())
        ((symbol? (car controller-text))
         (extract-instructions (cdr controller-text)))
        (else (cons (car controller-text)
                  (extract-instructions (cdr controller-text))))))


(define (make-register name)
  (let ((contents '*unassigned*))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set)
             (lambda (value) (set! contents value)))
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch))

(define (get-contents register)
  (register 'get))

(define (set-contents! register value)
  ((register 'set) value))

(define (pop stack)
  (stack 'pop))

(define (push stack value)
  ((stack 'push) value))

;**monitored version from section 5.2.4
(define (make-stack)
  (let ((s '())
        (number-pushes 0)
        (max-depth 0)
        (current-depth 0))
    (define (push x)
      (set! s (cons x s))
      (set! number-pushes (+ 1 number-pushes))
      (set! current-depth (+ 1 current-depth))
      (set! max-depth (max current-depth max-depth)))
    (define (pop)
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (car s)))
            (set! s (cdr s))
            (set! current-depth (- current-depth 1))
            top)))    
    (define (initialize)
      (set! s '())
      (set! number-pushes 0)
      (set! max-depth 0)
      (set! current-depth 0)
      'done)
    (define (print-statistics)
      (newline)
      (display (list 'total-pushes  '= number-pushes
                     'maximum-depth '= max-depth)))
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) (pop))
            ((eq? message 'initialize) (initialize))
            ((eq? message 'print-statistics)
             (print-statistics))
            (else
             (error "Unknown request -- STACK" message))))
    dispatch))

(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
        (instruction-count 0)
        (is-tracing false))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 (list 'print-stack-statistics
                       (lambda () (stack 'print-statistics)))
                 ))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
              (cadr val)
              (begin
               (allocate-register name)
               (lookup-register name)))))
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
                (if is-tracing
                    (begin
                      (display (instruction-text (car insts)))
                      (newline)))
                (set! instruction-count (+ instruction-count 1))
                ((instruction-execution-proc (car insts)))
                (execute)))))
      (define (sources register)
        (map
         (lambda (inst)
          (let ((exp (cddr (instruction-text inst))))
            (cond ((operation-exp? exp) exp)
                  (else (car exp)))))
         (filter
          (lambda (inst) (is-source? inst register))
          (dispatch 'get-instructions))))
      (define (dispatch message)
        (cond ((eq? message 'start)
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)
              ((eq? message 'get-register) lookup-register)
              ((eq? message 'install-operations)
               (lambda (ops) (set! the-ops (append the-ops ops))))
              ((eq? message 'stack) stack)
              ((eq? message 'operations) the-ops)
              ((eq? message 'get-instructions)    (sort (remove-duplicate-instructions the-instruction-sequence) alpha-order))
              ((eq? message 'get-entry-points)    (filter entry-point? (dispatch 'get-instructions)))
              ((eq? message 'get-saved-registers) (remove-duplicates (map (lambda (inst) (cadr (instruction-text inst))) 
                                                                          (filter stacked? (dispatch 'get-instructions)))))
              ((eq? message 'get-sources) sources)
              ((eq? message 'get-register-names) (map car register-table))
              ((eq? message 'trace-on) (set! is-tracing #t))
              ((eq? message 'trace-off) (set! is-tracing #f))
              ((eq? message 'get-instruction-count)
               (let ((old-count instruction-count))
                 (set! instruction-count 0)
                 old-count))
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

(define (is-source? inst name)
  (let ((op     (car (instruction-text inst)))
        (target (cadr (instruction-text inst))))
    (and (eq? op 'assign)
         (eq? target name))))

(define (entry-point? inst)
  (eq? (car (instruction-text inst)) 'goto))

(define (stacked? inst)
  (let ((op (car (instruction-text inst))))
    (or (eq? op 'restore)
        (eq? op 'save))))

(define (delete-inst inst lst)
  (cond ((null? lst) '())
        ((equal? (instruction-text inst) (instruction-text (car lst)))
         (delete-inst inst (cdr lst)))
        (else
         (cons (car lst) (delete-inst inst (cdr lst))))))

(define (remove-duplicates lst)
  (if (null? lst)
      '()
      (cons (car lst) (remove-duplicates (delete (car lst) (cdr lst))))))

(define (remove-duplicate-instructions lst)
  (if (null? lst)
      '()
       (cons (car lst) (remove-duplicate-instructions (delete-inst (car lst) (cdr lst))))))

(define (difference lst1 lst2)
  (cond ((null? lst1) '())
        ((member (car lst1) lst2)
         (difference (cdr lst1) lst2))
        (else
         (cons (car lst1) (difference (cdr lst1) lst2)))))

(define (sort lst pred)
  (if (null? lst)
      '()
      (let* ((tops    (filter (lambda (e) (pred e (car lst))) (cdr lst)))
             (bottoms (difference (cdr lst) tops)))
        (append
         (sort tops pred)
         (list (car lst))
         (sort bottoms pred)))))

(define (alpha-order inst1 inst2)
  (symbol-list<? (instruction-text inst1)
                 (instruction-text inst2)))

(define (meh x)
  (or (symbol? x) (number? x)))

(define (cmp one two)
  (cond ((and (number? one) (number? two))
         (< one two))
        ((number? one) #f)
        ((number? two) #t)
        (else (symbol<? one two))))

(define (symbol-list<? lst1 lst2)
  (cond ((and (null? lst1) (null? lst2)) #f)
        ((null? lst1) #t)
        ((null? lst2) #f)
        ((and (meh (car lst1)) (meh (car lst2)))
         (if (eq? (car lst1) (car lst2))
             (symbol-list<? (cdr lst1) (cdr lst2)) ; nothing to see here
             (cmp (car lst1) (car lst2))))
        ((meh (car lst1)) #t)
        ((meh (car lst2)) #f)
        ((equal? (car lst1) (car lst2))
         (symbol-list<? (cdr lst1) (cdr lst2)))    ; nothing to see here either
        (else (symbol-list<? (car lst1) (car lst2)))))

(define (start machine)
  (machine 'start))

(define (get-register-contents machine register-name)
  (get-contents (get-register machine register-name)))

(define (set-register-contents! machine register-name value)
  (set-contents! (get-register machine register-name) value)
  'done)

(define (get-register machine reg-name)
  ((machine 'get-register) reg-name))

(define (assemble controller-text machine)
  (extract-labels controller-text
    (lambda (insts labels)
      (update-insts! insts labels machine)
      insts)))

(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)
       (lambda (insts labels)
         (let ((next-inst (car text)))
           (if (symbol? next-inst)
               (receive insts
                        (cons (make-label-entry next-inst
                                                insts)
                              labels))
               (receive (cons (make-instruction next-inst)
                              insts)
                        labels)))))))

(define (update-insts! insts labels machine)
  (let ((pc (get-register machine 'pc))
        (flag (get-register machine 'flag))
        (stack (machine 'stack))
        (ops (machine 'operations)))
    (for-each
     (lambda (inst)
       (set-instruction-execution-proc!
        inst
        (make-execution-procedure
         (instruction-text inst) labels machine
         pc flag stack ops)))
     insts)))

(define (make-instruction text)
  (cons text '()))

(define (instruction-text inst)
  (car inst))

(define (instruction-execution-proc inst)
  (cdr inst))

(define (set-instruction-execution-proc! inst proc)
  (set-cdr! inst proc))

(define (make-label-entry label-name insts)
  (cons label-name insts))

(define (lookup-label labels label-name)
  (let ((val (assoc label-name labels)))
    (if val
        (cdr val)
        (error "Undefined label -- ASSEMBLE" label-name))))


(define (make-execution-procedure inst labels machine
                                  pc flag stack ops)
  (cond ((eq? (car inst) 'assign)
         (make-assign inst machine labels ops pc))
        ((eq? (car inst) 'test)
         (make-test inst machine labels ops flag pc))
        ((eq? (car inst) 'branch)
         (make-branch inst machine labels flag pc))
        ((eq? (car inst) 'goto)
         (make-goto inst machine labels pc))
        ((eq? (car inst) 'save)
         (make-save inst machine stack pc))
        ((eq? (car inst) 'restore)
         (make-restore inst machine stack pc))
        ((eq? (car inst) 'perform)
         (make-perform inst machine labels ops pc))
        (else (error "Unknown instruction type -- ASSEMBLE"
                     inst))))


(define (make-assign inst machine labels operations pc)
  (let ((target
         (get-register machine (assign-reg-name inst)))
        (value-exp (assign-value-exp inst)))
    (let ((value-proc
           (if (operation-exp? value-exp)
               (make-operation-exp
                value-exp machine labels operations)
               (make-primitive-exp
                (car value-exp) machine labels))))
      (lambda ()                ; execution procedure for assign
        (set-contents! target (value-proc))
        (advance-pc pc)))))

(define (assign-reg-name assign-instruction)
  (cadr assign-instruction))

(define (assign-value-exp assign-instruction)
  (cddr assign-instruction))

(define (advance-pc pc)
  (set-contents! pc (cdr (get-contents pc))))

(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
    (if (operation-exp? condition)
        (let ((condition-proc
               (make-operation-exp
                condition machine labels operations)))
          (lambda ()
            (set-contents! flag (condition-proc))
            (advance-pc pc)))
        (error "Bad TEST instruction -- ASSEMBLE" inst))))

(define (test-condition test-instruction)
  (cdr test-instruction))


(define (make-branch inst machine labels flag pc)
  (let ((dest (branch-dest inst)))
    (if (label-exp? dest)
        (let ((insts
               (lookup-label labels (label-exp-label dest))))
          (lambda ()
            (if (get-contents flag)
                (set-contents! pc insts)
                (advance-pc pc))))
        (error "Bad BRANCH instruction -- ASSEMBLE" inst))))

(define (branch-dest branch-instruction)
  (cadr branch-instruction))


(define (make-goto inst machine labels pc)
  (let ((dest (goto-dest inst)))
    (cond ((label-exp? dest)
           (let ((insts
                  (lookup-label labels
                                (label-exp-label dest))))
             (lambda () (set-contents! pc insts))))
          ((register-exp? dest)
           (let ((reg
                  (get-register machine
                                (register-exp-reg dest))))
             (lambda ()
               (set-contents! pc (get-contents reg)))))
          (else (error "Bad GOTO instruction -- ASSEMBLE"
                       inst)))))

(define (goto-dest goto-instruction)
  (cadr goto-instruction))

(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (push stack (get-contents reg))
      (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (set-contents! reg (pop stack))    
      (advance-pc pc))))

(define (stack-inst-reg-name stack-instruction)
  (cadr stack-instruction))

(define (make-perform inst machine labels operations pc)
  (let ((action (perform-action inst)))
    (if (operation-exp? action)
        (let ((action-proc
               (make-operation-exp
                action machine labels operations)))
          (lambda ()
            (action-proc)
            (advance-pc pc)))
        (error "Bad PERFORM instruction -- ASSEMBLE" inst))))

(define (perform-action inst) (cdr inst))

(define (make-primitive-exp exp machine labels)
  (cond ((constant-exp? exp)
         (let ((c (constant-exp-value exp)))
           (lambda () c)))
        ((label-exp? exp)
         (let ((insts
                (lookup-label labels
                              (label-exp-label exp))))
           (lambda () insts)))
        ((register-exp? exp)
         (let ((r (get-register machine
                                (register-exp-reg exp))))
           (lambda () (get-contents r))))
        (else
         (error "Unknown expression type -- ASSEMBLE" exp))))

(define (register-exp? exp) (tagged-list? exp 'reg))

(define (register-exp-reg exp) (cadr exp))

(define (constant-exp? exp) (tagged-list? exp 'const))

(define (constant-exp-value exp) (cadr exp))

(define (label-exp? exp) (tagged-list? exp 'label))

(define (label-exp-label exp) (cadr exp))


(define (make-operation-exp exp machine labels operations)
  (let ((op (lookup-prim (operation-exp-op exp) operations))
        (aprocs
         (map (lambda (e)
                (make-primitive-exp e machine labels))
              (operation-exp-operands exp))))
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs)))))

(define (operation-exp? exp)
  (and (pair? exp) (tagged-list? (car exp) 'op)))
(define (operation-exp-op operation-exp)
  (cadr (car operation-exp)))
(define (operation-exp-operands operation-exp)
  (cdr operation-exp))


(define (lookup-prim symbol operations)
  (let ((val (assoc symbol operations)))
    (if val
        (cadr val)
        (error "Unknown operation -- ASSEMBLE" symbol))))

;; from 4.1
(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

'(REGISTER SIMULATOR LOADED)
