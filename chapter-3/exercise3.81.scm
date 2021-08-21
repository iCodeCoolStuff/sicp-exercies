(define (make-random input-stream)
  (define rand-init 12345)
  (define (rand-update n)
    (+ n 1))
  (define (make-random-stream random-init)
    (define random-numbers
      (cons-stream
        random-init
        (stream-map rand-update random-numbers)))
    random-numbers)
  (define (make-rand r-stream i-stream)
    (cond ((eq? (stream-car i-stream) 'generate)
	   (cons-stream
	     (stream-car r-stream)
	     (make-rand (stream-cdr r-stream) (stream-cdr i-stream))))
          ((eq? (stream-car i-stream) 'reset)
	   (lambda (n)
	     (make-rand (make-random-stream n) (stream-cdr i-stream))))
	  (else
	    (error "Unknown operation -- STREAM-FUNC" (stream-car i-stream)))))
  (make-rand (make-random-stream rand-init) input-stream))


(define g-stream
  (cons-stream 'generate g-stream))
(define reset-stream
  (cons-stream 'reset reset-stream))

(define stream-3
  (cons-stream
    'generate
    (cons-stream
      'generate
      (cons-stream
	'reset
	stream-3))))

(define (test)
  (make-random stream-3))
