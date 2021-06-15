; a
(define (get-record key)
  ((get 'retrieve-record 'record-type') key))

; b
(define (get-salary record)
  ((get 'salary 'record-type) record))

; c
(define (find-employee-record name files)
  (if (null? files)
      #f
      (let ((file (car files))
	    (record (get-record (key file)))
	    (record-name ((get 'name 'record-type) record)))
	(if (equal? record-name name)
	    record
	    (find-employee-record name (cdr files))))))

; d
; They add the new personnel files into their file database, and they add the new record-types and record selectors into
; their operation-and-type table.
