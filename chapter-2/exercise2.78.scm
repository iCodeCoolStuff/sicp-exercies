(define (type-tag z)
  (cond ((number? z) 'number)
        ((pair? z) (car z))
	(else (error "Bad tagged datum -- TYPE-TAG" datum))))
       
(define (contents z)
  (cond ((number? z) z)
        ((pair? z) (cdr z))
	(else (error "Bad tagged datum -- CONTENTS" datum))))

(define (attach-tag type-tag contents)
  (if (number? contents)
      contents
      (cons type-tag contents)))

; I may have cheated a bit because the answer wasn't exactly obvious
