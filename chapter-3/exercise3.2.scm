(define (make-monitored func)
  (let ((count 0))
    (lambda (input)
      (if (eq? input 'how-many-calls?)
	  count
	  (begin (set! count (+ count 1))
	         (func input))))))

(define (test)
  (define s (make-monitored sqrt))
  (display (s 10))(newline)
  (s 'how-many-calls?))
