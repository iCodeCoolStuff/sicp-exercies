(define (curried-proc machine labels)
  (lambda (exp)
   (err-if-label-otherwise-make-primitive-exp machine labels exp)))

(define (err-if-label-otherwise-make-primitive-exp machine labels exp)
  (if (label-exp? exp)
      (error "Can't perform operation on a label - " exp)
      (make-primitive-exp exp machine labels)))

(define (make-operation-exp exp machine labels operations)
  (let ((op (lookup-prim (operation-exp-op exp) operations))
        (aprocs
         (map (curried-proc machine labels)
              (operation-exp-operands exp))))
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs)))))
