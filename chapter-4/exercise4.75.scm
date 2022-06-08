(define (singleton-stream? stream)
  (and (not (stream-null? stream))
       (not (null? (stream-car stream)))
       (stream-null? (stream-cdr stream))))

(define (uniquely-asserted singleton-list frame-stream)
  (stream-flatmap
    (lambda (frame)
      (let ((result (qeval (car singleton-list) (singleton-stream frame))))
        (if (singleton-stream? result)
            result
            the-empty-stream)))
    frame-stream))

(put 'unique 'qeval uniquely-asserted)

(and (job ?person ?role) (unique (supervisor ?supervised ?person)))
