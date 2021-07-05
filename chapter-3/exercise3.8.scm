(define f-init 0)

(define (f arg)
  (let ((x f-init))
    (define result
      (begin 
    	(if (= x 0)
	    arg
       	    0)))
    (begin 
	(set! f-init (+ x 1))
	  result)))
