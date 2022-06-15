; One of the quirks with this query system is that there are no duplicates.
;
; (and (supervisor ?x ?y)
;      (not (job ?x (computer programmer))))
; 
; Some infinite loops always return a valid answer no matter how many times you type try-again
;
; (married Mickey ?who)
;
; Some infinite loops don't print anything
;
; (last-pair ?x (1 2 3))
;
; recursive calls to a rule at the beginning of an and-clause will loop forever
;
; (outranked-by ?staff-person ?boss) ; louis's version
; (?relationship Adam Irad)


(define input-prompt ";;; Query input:")
(define output-prompt ";;; Query results:")
(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))
(define (announce-output string)
  (newline) (display string) (newline))

(define (query-syntax-process exp)
  (map-over-symbols expand-question-mark exp))

(define (map-over-symbols proc exp)
  (cond ((pair? exp)
         (cons (map-over-symbols proc (car exp))
               (map-over-symbols proc (cdr exp))))
        ((symbol? exp) (proc exp))
        (else exp)))

(define (query-driver-loop)
  (define (internal-loop try-again)
    (prompt-for-input input-prompt)
    (let ((q (query-syntax-process (read))))
      (if (eq? q 'try-again)
          (try-again)
          (cond ((assertion-to-be-added? q)
                 (add-rule-or-assertion! (body q))
                 (newline)
                 (display "Assertion added to data base.")
                 (query-driver-loop))
                (else
                 (newline)
                 (display output-prompt)
                 (ambeval q
                   (lambda (val next-alternative)
                    (newline)
                    (display (instantiate q val))
                    (internal-loop next-alternative))
                   (lambda ()
                    (announce-output 
                     ";;; There are no more values of")
                    (newline)
                    (display q)
                    (query-driver-loop))
                    (make-environment)))))))
  (internal-loop
   (lambda ()
    (newline)
    (display ";;; There is no current problem")
    (query-driver-loop))))

;;; Environments

(define the-empty-environment '())
(define (empty-env? env) (eq? env the-empty-environment))
(define (make-environment) the-empty-environment)
(define (make-environment-binding var val) (cons var val))
(define (extend-environment var val env) (cons (make-environment-binding var val) env))
(define (binding-variable binding) (car binding))
(define (binding-value binding) (cdr binding))
(define (binding-in-environment var env) (assoc var env))

;;; Data types

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (var? exp)
  (tagged-list? exp '?))

;;; Query Syntax

(define (empty-exp? exp) (null? exp))

(define (type exp)
  (if (pair? exp)
      (car exp)
      (error "Unknown expression TYPE" exp)))

(define (contents exp)
  (if (pair? exp)
      (cdr exp)
      (error "Unknown expression CONTENTS" exp)))

(define (assertion-to-be-added? maybe-assertion)
  (eq? (type maybe-assertion) 'assert!))

(define (rule? maybe-rule)
  (eq? (type maybe-rule) 'rule))

(define (body syntax)
  (car (contents syntax)))

(define (query? exp)
  (define (contains-variables? syntax)
    (cond((var?  syntax) true)
         ((pair? syntax) (or (contains-variables? (car syntax)) (contains-variables? (cdr syntax))))
         (else false)))
  (contains-variables? exp))

(define (always-true? exp)
  (equal? exp '(always-true)))

(define (and? exp)
  (tagged-list? exp 'and))

(define (and-conjuncts and-exp)
  (contents and-exp))

(define (first-conjunct conjuncts)
  (car conjuncts))
 
(define (rest-conjuncts conjuncts)
  (cdr conjuncts))

(define (or? exp)
  (tagged-list? exp 'or))

(define (or-disjuncts exp)
  (contents exp))

(define (first-disjunct disjuncts)
  (car disjuncts))

(define (rest-disjuncts disjuncts)
  (cdr disjuncts))

(define (not? exp)
  (tagged-list? exp 'not))

(define (negation exp)
  (car (contents exp)))

(define (expand-question-mark symbol)
  (let ((chars (symbol->string symbol)))
    (if (string=? (substring chars 0 1) "?")
        (list '?
              (string->symbol
               (substring chars 1 (string-length chars))))
        symbol)))

(define (contract-question-mark variable)
  (string->symbol
   (string-append "?" 
     (if (number? (cadr variable))
         (string-append (symbol->string (caddr variable))
                        "-"
                        (number->string (cadr variable)))
         (symbol->string (cadr variable))))))

;;; Eval

(define (ambeval exp succeed fail env)
  ((analyze exp) succeed fail env))

(define (instantiate query env)
  (define (replace exp)
    (cond ((empty-exp? exp) '())
          ((var? exp)
           (let ((b (binding-in-environment exp env)))
             (if b
                 (replace (binding-value b))
                 (contract-question-mark exp))))
          ((pair? exp)
           (cons (replace (car exp)) (replace (cdr exp))))
          (else exp)))
  (replace query))

;;; Analyze

(define (analyze-simple-query exp)
  (lambda (succeed fail env)
    (match-assertions exp succeed
                          (lambda ()
                            (apply-rules exp succeed fail env))
                          env)))

(define (analyze-and exp)
  (lambda (succeed fail env)
    (let ((conjuncts (and-conjuncts exp)))
      (define (eval-next cjs cont-fail environment)
        (if (null? cjs)
            (succeed environment cont-fail)
            (ambeval
              (first-conjunct cjs)
              (lambda (new-env fail2)
                (eval-next (rest-conjuncts cjs) fail2 new-env))
              cont-fail
              environment)))
        (eval-next conjuncts fail env))))
          
(define (analyze-or exp)
  (lambda (succeed fail env)
    (let ((disjuncts (or-disjuncts exp)))
      (define (eval-next disjuncts environment)
        (if (null? disjuncts)
            (fail)
            (ambeval
              (first-disjunct disjuncts)
              succeed
              (lambda ()
                (eval-next (rest-disjuncts disjuncts) environment))
              environment)))
      (eval-next disjuncts env))))

(define (analyze-not exp)
  (lambda (succeed fail env)
    (ambeval
      (negation exp)
      (lambda (val fail2)
       (fail))
      (lambda ()
       (succeed env fail))
      env)))

(define (analyze-always-true exp)
  (lambda (succeed fail env)
    (succeed env fail)))

(define (analyze exp)
  (cond ((always-true? exp) (analyze-always-true exp))
        ((and?   exp) (analyze-and exp))
        ((or?    exp) (analyze-or  exp))
        ((not?   exp) (analyze-not exp))
        ((query? exp) (analyze-simple-query exp))
        (else
          (error "Invalid expression -- ANALYZE" exp))))

;;; Pattern Matching

(define (pattern-match p1 p2 succeed fail env)
  (cond ((and (null? p1) (null? p2)) (succeed env fail))
        ((var? p1)
         (extend-if-consistent p1 p2 succeed fail env))
        ((equal? p1 p2)
         (succeed env fail))
        ((and (pair? p1) (pair? p2))
         (pattern-match (car p1) (car p2)
                        (lambda (new-env fail2)
                          (pattern-match (cdr p1) (cdr p2) succeed fail2 new-env))
                        fail
                        env))
        (else (fail))))

(define (extend-if-consistent var val succeed fail env)
  (let ((b (binding-in-environment var env)))
    (if b
        (pattern-match (binding-value b) val succeed fail env)
        (pattern-match val val succeed fail (extend-environment var val env)))))

;;; Unification

(define (unify-match p1 p2 succeed fail env)
  (cond ((and (null? p1) (null? p2)) (succeed env fail))
        ((equal? p1 p2) (succeed env fail))
        ((var? p1) (extend-if-possible p1 p2 succeed fail env))
        ((var? p2) (extend-if-possible p2 p1 succeed fail env))
        ((and (pair? p1) (pair? p2))
         (unify-match (car p1) (car p2) (lambda (new-env fail2)
                                         (unify-match (cdr p1) (cdr p2) succeed fail2 new-env))
                                        fail
                                        env))
        (else (fail))))

(define (extend-if-possible var val succeed fail env)
  (let ((b (binding-in-environment var env)))
    (cond (b
           (unify-match
            (binding-value b) val succeed fail env))
          ((var? val)
           (let ((binding (binding-in-environment val env)))
             (if binding
                 (unify-match var (binding-value binding) succeed fail env)
                 (succeed (extend-environment val var env) fail))))
          ((depends-on? var val env)
           (fail))
          (else (succeed (extend-environment var val env) fail)))))

(define (depends-on? exp var env)
  (define (tree-walk e)
    (cond ((var? e)
           (if (equal? var e)
               true
               (let ((b (binding-in-environment e env)))
                 (if b
                     (tree-walk (binding-value b))
                     false))))
          ((pair? e)
           (or (tree-walk (car e))
               (tree-walk (cdr e))))
          (else false)))
  (tree-walk exp))

;;; Database

(define THE-ASSERTIONS '())
(define (get-all-assertions) THE-ASSERTIONS)
(define (first-assertion assertions) (car assertions))
(define (rest-assertions assertions) (cdr assertions))

(define (fetch-assertions pattern)
  (get-all-assertions)) ; will index later

(define THE-RULES '())
(define (get-all-rules) THE-RULES)
(define (first-rule rules) (car rules))
(define (rest-rules rules) (cdr rules))

(define (add-rule-or-assertion! ?)
  (if (rule? ?)
      (add-a-rule!       ?)
      (add-an-assertion! ?)))

(define (add-an-assertion! assertion)
  (set! THE-ASSERTIONS (cons assertion THE-ASSERTIONS)))

(define (add-a-rule! rule)
  (set! THE-RULES (cons rule THE-RULES)))

;;; Assertions

(define (check-an-assertion query-pattern assertion succeed fail env)
  (pattern-match query-pattern assertion succeed fail env))

(define (match-assertions query-pattern succeed fail env)
  (define (try-next assertions)
    (if (null? assertions)
        (fail)
        (check-an-assertion query-pattern
                            (car assertions)
                            succeed
                            (lambda ()
                             (try-next (cdr assertions)))
                            env)))
  (try-next (fetch-assertions query-pattern)))
    
;;; Rules

(define (conclusion rule) (cadr rule))
(define (rule-body rule)
  (if (null? (cddr rule))
      '(always-true)
      (caddr rule)))

(define (apply-a-rule rule pattern succeed fail env)
  (let ((clean-rule (rename-variables-in rule)))
    (unify-match pattern (conclusion clean-rule)
                                     (lambda (new-env fail2)
                                       (ambeval (rule-body clean-rule)
                                                succeed
                                                fail2
                                                new-env))
                                     fail
                                     env)))

(define (apply-rules pattern succeed fail env)
  (define (try-next rules)
    (if (null? rules)
        (fail)
        (apply-a-rule (car rules) pattern
                              succeed
                              (lambda ()
                               (try-next (cdr rules)))
                              env)))
  (try-next (get-all-rules)))

(define (rename-variables-in rule)
  (let ((rule-application-id (new-rule-application-id)))
    (define (tree-walk exp)
      (cond ((var? exp)
             (make-new-variable exp rule-application-id))
            ((pair? exp)
             (cons (tree-walk (car exp))
                   (tree-walk (cdr exp))))
            (else exp)))
    (tree-walk rule)))

(define rule-counter 0)

(define (new-rule-application-id)
  (set! rule-counter (+ 1 rule-counter))
  rule-counter)

(define (make-new-variable var rule-application-id)
  (cons '? (cons rule-application-id (cdr var))))

;;; Execute
(query-driver-loop)
