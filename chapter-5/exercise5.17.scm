;; Inside make-new-machine :

(define (execute)
  (let ((insts (get-contents pc)))
    (if (null? insts)
        'done
        (begin
          (if is-tracing
              (begin
                (if (not (null? (preceeding-label (car insts))))
                    (begin
                      (display (preceeding-label (car insts)))
                      (display ":")
                      (newline)))
                (display "  ")
                (display (instruction-text (car insts)))
                (newline)
          (set! instruction-count (+ instruction-count 1))
          ((instruction-execution-proc (car insts)))
          (execute)))))))

; -------------------------------------

(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)
       (lambda (insts labels)
         (let ((next-inst (car text)))
           (if (symbol? next-inst)
               (begin
                 (if (not (null? insts))
                     (set-preceeding-label! (car insts) next-inst))
                 (receive insts
                          (cons (make-label-entry next-inst
                                                  insts)
                                labels)))
               (receive (cons (make-instruction next-inst)
                              insts)
                        labels)))))))

; -------------------------------------

(define (make-instruction text)
  (list text '() '()))

(define (instruction-text inst)
  (car inst))

(define (instruction-execution-proc inst)
  (cadr inst))

(define (preceeding-label inst)
  (caddr inst))

(define (set-instruction-execution-proc! inst proc)
  (set-car! (cdr inst) proc))

(define (set-preceeding-label! inst label)
  (set-car! (cddr inst) label))
