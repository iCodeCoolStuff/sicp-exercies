; Ben just realized that the query system gives duplicate responses, so any accumulation
; query may be inaccurate.

; a simple scheme to salvage the situation is to filter duplicate responses. This is implemented below by creating a remove-duplicates function and feeding
; the result of qeval into that function.

(define unknown-pattern-var
	(lambda (v f)
		(error "Unknown pat var -- REMOVE-DUPLICATES" v)))

(define (remove-duplicates query frame-stream)
  (define duplicate-query-list '())
	(define (empty-or-singleton-stream-of frame)
		(define instantiated-query (instantiate query frame unknown-pattern-var))
		(if (member instantiated-query duplicate-query-list)
		    the-empty-stream
		    (begin
					(set! duplicate-query-list (cons instantiated-query duplicate-query-list))
					(singleton-stream frame))))
  (stream-flatmap empty-or-singleton-stream-of frame-stream))

(define (qeval query frame-stream)
  (define (result)
		(let ((qproc (get (type query) 'qeval)))
			(if qproc
					(qproc (contents query) frame-stream)
					(simple-query query frame-stream))))
  (remove-duplicates query (result)))
