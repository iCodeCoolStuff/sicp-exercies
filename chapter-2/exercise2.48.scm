(define (make-line-segment start-vector end-vector)
  (cons start-vector end-vector))

(define start-segment car)
(define end-segment cdr)
