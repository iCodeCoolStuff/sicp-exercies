(define the-machine
  (make-machine
    (list 'a)
    '()
    '(start
       (goto (label here))
     here
       (assign a (const 3))
       (goto (label there))
     here
       (assign a (const 4))
       (goto (label there))
     there)))

(start the-machine)
(get-register-contents the-machine 'a) ; 3

(define (extract-labels text receive)
  (define label-history '())
  (define add-to-history! (lambda (label) (set! label-history (cons label label-history))))
  (define (inner t r)
    (if (null? t)
        (r '() '())
        (inner (cdr t)
         (lambda (insts labels)
           (let ((next-inst (car t)))
             (if (symbol? next-inst)
                 (if (memq next-inst label-history)
                     (error "duplicate label in machine --" next-inst)
                     (begin
                       (add-to-history! next-inst)
                       (r insts
                          (cons (make-label-entry next-inst
                                                  insts)
                                labels))))
                 (r (cons (make-instruction next-inst)
                          insts)
                    labels)))))))
  (inner text receive))
