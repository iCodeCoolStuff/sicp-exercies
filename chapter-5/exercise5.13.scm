; a)

(define (make-machine ops controller-text)
  (let ((machine (make-new-machine))
        (register-names (reg-names controller-text)))
    (for-each (lambda (register-name)
                ((machine 'allocate-register) register-name))
              register-names)
    ((machine 'install-operations) ops)
    ((machine 'install-instruction-sequence)
     (assemble controller-text machine))
    machine))

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

(define (is-assigned? inst-text)
  (eq? (car inst-text) 'assign))

; b)

(define (make-machine ops controller-text)
  (let ((machine (make-new-machine)))
    ((machine 'install-operations) ops)
    ((machine 'install-instruction-sequence)
     (assemble controller-text machine))
    machine))

; Change to lookup-register inside of make-new-machine
(define (lookup-register name)
  (let ((val (assoc name register-table)))
    (if val
        (cadr val)
        (begin
         (allocate-register name)
         (lookup-register name)))))
