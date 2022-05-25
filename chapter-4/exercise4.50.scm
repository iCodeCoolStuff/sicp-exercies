(define (amb? exp) (tagged-list? exp 'amb))
(define (ramb? exp) (tagged-list? exp 'ramb))
(define (amb-choices exp) (cdr exp))
(define (ramb-choices exp) (cdr exp))
(define (ambeval exp env succeed fail)
  ((analyze exp) env succeed fail))

(define (analyze-amb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
	(if (null? choices)
	    (fail)
	    ((car choices) env
			   succeed
			   (lambda ()
			     (try-next (cdr choices))))))
    (try-next cprocs))))

(define (analyze-ramb exp)
  (let ((cprocs (map analyze (ramb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
	(if (null? choices)
	  (fail)
	  (let ((random-choice (list-ref choices (random-integer (length choices)))))
	    (random-choice
	     env
	     succeed
	     (lambda ()
	       (try-next (delete random-choice choices)))))))
      (try-next cprocs))))

(define (analyze exp)
  (cond ((self-evaluating? exp)
	 (analyze-self-evaluating exp))
	((quoted? exp) (analyze-quoted exp))
	((variable? exp) (analyze-variable exp))
	((assignment? exp) (analyze-assignment exp))
	((definition? exp) (analyze-definition exp))
	((if? exp) (analyze-if exp))
	((not? exp) (analyze-not exp))
	((and? exp) (analyze-and exp))
	((or? exp) (analyze-or exp))
	((let? exp) (analyze-let exp))
	((lambda? exp) (analyze-lambda exp))
	((begin? exp) (analyze-sequence (begin-actions exp)))
	((cond? exp) (analyze (cond->if exp)))
	((amb? exp) (analyze-amb exp))
	((ramb? exp) (analyze-ramb exp))
	((application? exp) (analyze-application exp))
	(else
	  (error "Unknown expression type -- ANALYZE" exp))))

(define (analyze-self-evaluating exp)
  (lambda (env succeed fail)
    (succeed exp fail)))

(define (analyze-quoted exp)
  (let ((qval (text-of-quotation exp)))
    (lambda (env succeed fail)
      (succeed qval fail))))

(define (analyze-variable exp)
  (lambda (env succeed fail)
    (succeed (lookup-variable-value exp env)
	     fail)))

(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
	(vproc (analyze (assignment-value exp))))
    (lambda (env succeed fail)
      (vproc env
	     (lambda (val fail2)
	       (let ((old-value
		       (lookup-variable-value var env)))
		 (set-variable-value! var val env)
		 (succeed 'ok
			  (lambda ()
			    (set-variable-value! var
						 old-value
						 env)
			    (fail2)))))
	     fail))))

(define (analyze-definition exp)
  (let ((var (definition-variable exp))
	(vproc (analyze (definition-value exp))))
    (lambda (env succeed fail)
      (vproc env
	     (lambda (val fail2)
	       (define-variable! var val env)
	       (succeed 'ok fail2))
	     fail))))

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
	(cproc (analyze (if-consequent exp)))
	(aproc (analyze (if-alternative exp))))
    (lambda (env succeed fail)
      (pproc env
	     (lambda (pred-value fail2)
	       (if (true? pred-value)
		   (cproc env succeed fail2)
		   (aproc env succeed fail2)))
	     fail))))

(define (analyze-not exp)
  (let ((pproc (analyze (not-contents exp))))
    (lambda (env succeed fail)
      (pproc env
	     (lambda (pred-value fail2)
	       (if (true? pred-value)
		   (succeed false fail2)
		   (succeed true  fail2)))
        fail))))

(define (and? exp) (tagged-list? exp 'and))
(define (make-and clauses) (cons 'and clauses))
(define (and-clauses exp) (cdr exp))

(define (expand-and clauses)
  (if (null? clauses)
      'true
      (make-if (car clauses)
	       (expand-and (cdr clauses))
	       'false)))

(define (or? exp) (tagged-list? exp 'or))
(define (make-or clauses) (cons 'or clauses))
(define (or-clauses exp) (cdr exp))

(define (expand-or clauses)
  (if (null? clauses)
      'false
      (make-if (car clauses)
	       'true
	       (expand-or (cdr clauses)))))

(define (analyze-and exp)
  (analyze (expand-and (and-clauses exp))))

(define (analyze-or exp)
  (analyze (expand-or (or-clauses exp))))


(define (analyze-lambda exp)
  (let ((vars (lambda-parameters exp))
	(bproc (analyze-sequence (lambda-body exp))))
    (lambda (env succeed fail)
      (succeed (make-procedure vars bproc env)
	       fail))))

(define (analyze-let exp)
  (let ((vars (let-variables exp))
	(exps (let-exps      exp))
	(body (let-body      exp)))
    (analyze-application (cons (make-lambda vars body) exps))))

(define (analyze-sequence exps)
  (define (sequentially a b)
    (lambda (env succeed fail)
      (a env
	 (lambda (a-value fail2)
	   (b env succeed fail2))
	 fail)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
	first-proc
	(loop (sequentially first-proc (car rest-procs))
	      (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
	(error "Empty sequence -- ANALYZE"))
    (loop (car procs) (cdr procs))))

(define (analyze-application exp)
  (let ((fproc (analyze (operator exp)))
	(aprocs (map analyze (operands exp))))
    (lambda (env succeed fail)
      (fproc env
	     (lambda (proc fail2)
	       (get-args aprocs
			 env
			 (lambda (args fail3)
			   (execute-application
			     proc args succeed fail3))
			 fail2))
	     fail))))

(define (get-args aprocs env succeed fail)
  (if (null? aprocs)
      (succeed '() fail)
      ((car aprocs) env
		    (lambda (arg fail2)
		      (get-args (cdr aprocs)
				env
				(lambda (args fail3)
				  (succeed (cons arg args)
					   fail3))
				fail2))
		    fail)))

(define (execute-application proc args succeed fail)
  (cond ((primitive-procedure? proc)
	 (succeed (apply-primitive-procedure proc args)
		  fail))
	((compound-procedure? proc)
	 ((procedure-body proc)
	  (extend-environment (procedure-parameters proc)
			      args
			      (procedure-environment proc))
	  succeed
	  fail))
	(else
	  (error
	    "Unknown procedure type -- EXECUTE-APPLICATION"
	    proc))))


;(define (eval exp env)
  ;(cond ((self-evaluating? exp) exp)
        ;((variable? exp) (lookup-variable-value exp env))
	;((quoted? exp) (text-of-quotation exp))
	;((assignment? exp) (eval-assignment exp env))
	;((definition? exp) (eval-definition exp env))
	;((let? exp) (eval (let->combination exp) env))
	;((if? exp) (eval-if exp env))
	;((lambda? exp) (make-procedure (lambda-parameters exp)
				       ;;(lambda-body exp)
				       ;env))
	;((begin? exp)
	 ;(eval-sequence (begin-actions exp) env))
	;((cond? exp) (eval (cond->if exp) env))
	;((application? exp)
	 ;(apply (eval (operator exp) env)
		;(list-of-values (operands exp) env)))
	;(else
	  ;(error "Unknown expression type: EVAL" exp))))

(define (eval exp env)
  ((analyze exp) env))

(define apply-in-underlying-scheme apply)
(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
	 (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
	 (eval-sequence
	   (procedure-body procedure)
	   (extend-environment
	     (procedure-parameters procedure)
	     arguments
	     (procedure-environment procedure))))
	(else
	  (error
	    "Unknown procedure type: APPLY" procedure))))

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
	    (list-of-values (rest-operands exps) env))))

(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
	(else (eval (first-exp exps) env)
	      (eval-sequence (rest-exps exps) env))))

(define (not? exp) (tagged-list? exp 'not))
(define (make-not exp) (list 'not exp))
(define (not-contents exp) (cadr exp))
(define (eval-not exp env)
  (if (true? (eval (not-contents exp) env))
      false
      true))

(define (eval-sequences exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
	(else (eval (first-exp exps) env)
	      (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
		       (eval (assignment-value exp) env)
		       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
		    (eval (definition-value exp) env)
		    env)
  'ok)

(define (self-evaluating? exp)
  (cond ((number? exp) true)
	((string? exp) true)
	(else false)))

(define (variable? exp) (symbol? exp))
(define (quoted? exp) (tagged-list? exp 'quote))
(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (assignment? exp)
  (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))
(define (make-assignment var exp) (list 'set! var exp))
(define (definition? exp)
  (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))
(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)
		   (cddr exp))))

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))
(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))
(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
	((last-exp? seq) (first-exp seq))
	(else (make-begin seq))))
(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))
(define (expand-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
	    (rest (cdr clauses)))
	(if (cond-else-clause? first)
	    (if (null? rest)
		(sequence->exp (cond-actions first))
		(error "ELSE clause isn't last -- COND->IF"
		       clauses))
	    (make-if (cond-predicate first)
		     (sequence->exp (cond-actions first))
		     (expand-clauses rest))))))

(define (let? exp) (tagged-list? exp 'let))
(define (let-bindings exp) (cadr exp))
(define (let-variables exp) (map car (let-bindings exp)))
(define (let-exps      exp) (map cadr (let-bindings exp)))
(define (let-body exp) (cddr exp))
(define (let->combination exp)
  (cons (make-lambda (let-variables exp) 
		     (let-body exp)) (let-exps exp)))
(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (scan-out-defines (caddr p)))
(define (procedure-environment p) (cadddr p))
(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())
(define (make-frame variables values)
  (cons variables values))
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-bindings-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))
(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
	  (error "Too many arguments supplied" vars vals)
	  (error "Too few arguments supplied" vars vals))))
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
	     (env-loop (enclosing-environment env)))
	    ((eq? var (car vars))
	     (if (eq? (car vals) '*unassigned*)
		 (error "Unassigned variable" var)
	         (car vals)))
	    (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
	(error "Unbound variable" var)
	(let ((frame (first-frame env)))
	  (scan (frame-variables frame)
		(frame-values frame)))))
  (env-loop env))
(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
	     (env-loop (enclosing-environment env)))
	    ((eq? var (car vars))
	     (set-car! vals val))
	    (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
	(error "Unbound variable --SET!" var)
	(let ((frame (first-frame env)))
	  (scan (frame-variables frame)
		(frame-values frame)))))
  (env-loop env))
(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
	     (add-bindings-to-frame! var val frame))
	    ((eq? var (car vars))
	     (set-car! vals val))
	    (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
	  (frame-values frame))))

(define (filter pred lst)
  (cond ((null? lst) '())
	((pred (car lst)) (cons (car lst) (filter pred (cdr lst))))
	(else (filter pred (cdr lst)))))

(define (make-let bindings body)
  (list 'let bindings body))
(define (make-let-binding var exp)
  (list var exp))

(define (scan-out-defines proc-body)
  (if (not (pair? proc-body))
      proc-body
      (let ((defs (filter (lambda (exp) (tagged-list? exp 'define)) proc-body))
	    (exps (filter (lambda (exp) (not (tagged-list? exp 'define))) proc-body)))
        (if (null? defs)
	    exps
            (let ((vars (map definition-variable defs))
	          (vals (map definition-value    defs))
	          (assignments (map (lambda (x) (quote '*unassigned*)) defs)))
              (list (make-let (map make-let-binding vars assignments)
		        (append (map make-assignment vars vals)
				          exps))))))))
(define (true? x)
  (not (eq? x false)))
(define (false? x)
  (eq? x false))

(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))
(define (prime? n)
  (= n (smallest-divisor n)))

(define primitive-procedures
  (list (list 'car car)
    (list 'cadr cadr)
	(list 'cdr cdr)
	(list 'cons cons)
	(list 'list list)
	(list 'null? null?)
	(list '+ +)
	(list '- -)
	(list '* *)
	(list '/ /)
	(list '= =)
	(list '< <)
	(list '> >)
	(list '<= <=)
	(list '>= >=)
	(list 'exit exit)
	(list 'display display)
	(list 'prime? prime?)
	(list 'newline newline)
	(list 'sqrt sqrt)
	(list 'integer? integer?)
	(list 'memq memq)
	(list 'abs abs)
    (list 'member member)
    (list 'cadadr cadadr)
    (list 'caddr caddr)
    (list 'true? true?)
    (list 'false? false?)
    (list 'eq? eq?)
    (list 'length length)
    (list 'append append)
    (list 'random-integer random-integer)
    (list 'delete delete)
    (list 'list-ref list-ref)
	))
(define (primitive-procedure-names)
  (map car primitive-procedures))
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (setup-environment)
  (let ((initial-env
	  (extend-environment (primitive-procedure-names)
			      (primitive-procedure-objects)
			      the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))
(define the-global-environment (setup-environment))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme (primitive-implementation proc) args))

(define input-prompt ";;; Amb-Eval input:")
(define output-prompt ";;; Amb-Eval value:")
(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))
(define (announce-output string)
  (newline) (display string) (newline))
(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
		     (procedure-parameters object)
		     (procedure-body object)
		     '<procedure-env>))
      (display object)))

(define (driver-loop)
  (define (internal-loop try-again)
    (prompt-for-input input-prompt)
    (let ((input (read)))
      (if (eq? input 'try-again)
	  (try-again)
	  (begin
	    (newline)
	    (display ";;; Starting a new problem")
	    (ambeval input
		     the-global-environment
		     (lambda (val next-alternative)
		       (announce-output output-prompt)
		       (user-print val)
		       (internal-loop next-alternative))
		     (lambda ()
		       (announce-output
			 ";;; There are no more values of")
		       (user-print input)
		       (driver-loop)))))))
  (internal-loop
    (lambda ()
      (newline)
      (display ";;; There is no current problem")
      (driver-loop))))

(ambeval (list 'define (list 'require 'p) (list 'if (list 'not 'p) (list 'amb)))
         the-global-environment
         (lambda (val next-alternative) val)
         (lambda () 'fail))
(driver-loop)

(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))
(define articles '(article the a))
(define adjectives '(adjective red orange yellow green blue purple))
(define prepositions '(prep for to in by with))
(define adverbs      '(adverb slowly quickly steadily terribly))
(define conjunctions '(conj for and nor but or yet so))

(define *unparsed* '())
(define (parse input)
  (set! *unparsed* input)
  (let ((sent (parse-sentence)))
    (require (null? *unparsed*))
    sent))

(define (parse-sentence)
  (define (maybe-extend sentence)
    (ramb sentence
	 (append sentence
		 (list (parse-word conjunctions))
		 (list (parse-noun-phrase))
		 (parse-verb-phrase))))
  (maybe-extend
    (list 'sentence
          (parse-noun-phrase)
          (parse-verb-phrase))))

(define (parse-simple-noun-phrase)
  (append (list 'simple-noun-phrase
                (parse-word articles))
                (maybe-parse-adjective-list)))

(define (maybe-parse-adjective-list)
  (define (maybe-add-adjective adjective-phrase)
    (ramb (append adjective-phrase
		 (list (parse-word nouns)))
	 (maybe-add-adjective (append adjective-phrase
		                      (list (parse-word adjectives))))))
  (ramb (list (parse-word nouns))
       (maybe-add-adjective (list (parse-word adjectives)))))
	      
(define (parse-verb-phrase)
  (define (maybe-append-adverb verb-list)
    (ramb (maybe-append-adverb (append verb-list (list (parse-word adverbs))))
	 verb-list))
  (define (maybe-extend verb-phrase)
    (ramb verb-phrase
	 (maybe-extend (append verb-phrase
			       (list (parse-prepositional-phrase))))))
  (maybe-extend (maybe-append-adverb (list 'verb-phrase (parse-word verbs)))))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (ramb noun-phrase
	 (maybe-extend (list 'noun-phrase
			     noun-phrase
			     (parse-prepositional-phrase)))))
  (maybe-extend (parse-simple-noun-phrase)))

(define (parse-prepositional-phrase)
  (list 'prep-phrase
	(parse-word prepositions)
	(parse-noun-phrase)))

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (define (a-random-word-from wl)
    (list-ref (cdr wl) (random-integer (length (cdr wl)))))
  (let ((found-word (a-random-word-from word-list)))
    (set! *unparsed* (cdr *unparsed*))
    (list (car word-list) found-word)))
