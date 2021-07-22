(define (make-queue) (cons '() '()))
(define (front-ptr queue) (car queue))
(define (rear-ptr  queue) (cdr queue))
(define (set-front-ptr! queue item)
  (set-car! queue item))
(define (set-rear-ptr! queue item)
  (set-cdr! queue item))
(define (empty-queue? queue)
  (null? (front-ptr queue)))
(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
	   (set-front-ptr! queue new-pair)
	   (set-rear-ptr! queue new-pair)
	   queue)
          (else
	    (set-cdr! (rear-ptr queue) new-pair)
	    (set-rear-ptr! queue new-pair)
	    queue))))

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
	 (error "DELETE! called with an empty queue" queue))
        (else (set-front-ptr! queue (cdr (front-ptr queue)))
	      queue)))

(define (test)
  (define q1 (make-queue))
  (insert-queue! q1 'a)
  (insert-queue! q1 'b)
  (delete-queue! q1)
  (delete-queue! q1)
  (display (rear-ptr q1))
  
  )

; Eva Lu Ator is saying that the representation is correct. The rear-ptr is pointing to an item that isn't in the queue anymore,
; however, the rest of the queue is gone, so it does not matter to the upper-level operations like empty-queue?, insert-queue!, 
; and delete-queue!. The way to represent the queue visually is to simply print the front-ptr of the queue.

(define (print-queue queue)
  (display (front-ptr queue)))
