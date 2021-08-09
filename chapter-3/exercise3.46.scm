(define (clear! cell) (set-car! cell false))
(define (test-and-set! cell)
  (if (car cell) true (begin (set-car! cell true) false)))
(define (make-mutex)
  (let ((cell (list false)))
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
	     (if (test-and-set! cell)
		 (the-mutex 'acquire))) ;retry
	    ((eq? m 'release) (clear! cell))))
    the-mutex))
(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
      (define (serialized-p . args)
	(mutex 'acquire)
	(let ((val (apply p args)))
	  (mutex 'release)
	  val))
      serialized-p)))
;                                                                                                                                   
;         Initial balance: 100                                                                                                      
;                                                                                                                                   
;  |      Process1                      Process2                                                                                    
;  |                                                                                                                                
;  |      acquire-mutex                                                                                                             
;  |                                    acquire-mutex                                                                               
;  |      test-and-set!                                                                                                             
;  |                                    test-and-set!                                                                               
;  |      (car cell)                                                                                                                
;  |                                    (car cell)                                                                                  
;  |      (set-car! cell true)                                                                                                      
;  |                                    (set-car! cell true)                                                                        
;  |      false                                                                                                                     
;  |                                    false                                                                                       
;  |      (deposit 50)                                                                                                              
;  |                                    (withdraw 50)                                                                               
;  |      access balance                                                                                                            
;  |                                    access balance                                                                              
;  |      (set! balance (+ balance 50))                                                                                             
;  |                                    (set! balance (- balance 50))                                                               
;  |      release-mutex                                                                                                             
;  |                                    release-mutex                                                                               
;  |                                                                                                                                
;  |                                                                                                                                
;  |      Final balance: 50 (incorrect. should be 100)                                                                              
;  |                                                                                                                                
;  V                                                                                                                                
; time                                                                                                                              
