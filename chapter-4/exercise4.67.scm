; We define a global history variable called THE-HISTORY. It is defined as an empty list.
; In the loop-checker, each query with its pattern-matched frame from the previous step
; is instantiated keeping the unbound variables intact. It is then saved into the history.
; The equivalent-query-in-history? procedure takes the unified result of the conclusion
; of the current rule and instantiates the rule-body of the clean rule.
; equivalent-query-in-history? checks to see if the instantiated rule-body is equivalent
; to another query in the history. If there is, apply-a-rule returns the empty stream
; (otherwise the system would go into an infinite loop). If there isn't, the instantiated
; rule gets added to the history and the rule-body of the clean-rule is qeval'ed.

(define (equivalent-query-in-history? query)
  (define (inner history)
    (define (tree-walk p1 p2)
      (cond ((and (var? p1) (var? p2)) true)
            ((equal? p1 p2) true)
            ((and (pair? p1) (pair? p2))
             (and (tree-walk (car p1) (car p2))
                  (tree-walk (cdr p1) (cdr p2))))
            (else false)))
    (if (null? history)
        false
        (let ((prev-query (car history)))
            (if (tree-walk query prev-query)
                true
                (inner (cdr history))))))
  (inner THE-HISTORY))

(define keep-unbound-vars (lambda (v f) v))
(define (instantiate-keeping-unbound-vars pat frame)
  (instantiate pat frame keep-unbound-vars))

(define (apply-a-rule rule query-pattern query-frame)
  (add-to-history! (instantiate-keeping-unbound-vars query-pattern query-frame))
  (let ((clean-rule (rename-variables-in rule)))
    (let ((unify-result
      (unify-match query-pattern
       (conclusion clean-rule)
       query-frame)))
      (if (eq? unify-result 'failed)
          the-empty-stream
          (let ((prev-pat (instantiate-keeping-unbound-vars (rule-body clean-rule)
                                                            unify-result)))
            (cond ((equivalent-query-in-history? prev-pat) the-empty-stream)
            (else
              (add-to-history! prev-pat)
              (qeval (rule-body clean-rule)
               (singleton-stream unify-result)))))))))

(define THE-HISTORY '())
(define (add-to-history! query)
  (set! THE-HISTORY (cons query THE-HISTORY)))
(define (clear-history!)
  (set! THE-HISTORY '()))

; clear-history! is called after qeval in the driver loop.
(clear-history!)
