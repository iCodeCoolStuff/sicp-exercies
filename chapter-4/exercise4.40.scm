; Before distinction: 3125
; After distinction: 120

(define pool (list 1 2 3 4 5))

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(define (filter pred lst)
  (cond ((null? lst) '())
        ((pred (car lst)) (cons (car lst) (filter pred (cdr lst))))
        (else (filter pred (cdr lst)))))

(define (not-includes lst elems)
   (filter (lambda (e) (not (memq e elems))) lst))

(define (multiple-dwelling)
  (let ((baker (an-element-of pool)))
    (require (not (= baker 5)))
    (let ((cooper (an-element-of (not-includes pool (list baker)))))
      (require (not (= cooper 1)))
      (let ((fletcher (an-element-of (not-includes pool (list baker cooper)))))
        (require (not (= fletcher 5)))
        (require (not (= fletcher 1)))
        (require (not (= (abs (- fletcher cooper)) 1)))
        (let ((miller (an-element-of (not-includes pool (list baker cooper fletcher)))))
          (require (> miller cooper))
          (let ((smith (an-element-of (not-includes pool (list baker cooper fletcher miller)))))
            (require (not (= (abs (- smith fletcher)) 1)))
            (list (list 'baker baker)
                  (list 'cooper cooper)
                  (list 'fletcher fletcher)
                  (list 'miller miller)
                  (list 'smith smith))))))))
