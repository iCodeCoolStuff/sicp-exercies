(define (make-wire)
  (let ((signal 0)
	(actions '()))
    (define (set-signal! new-value)
      (begin (set! signal new-value)
	     (execute-actions actions)
	'ok))
    (define (execute-actions alist)
      (cond ((null? alist) 'done)
	    (else
	      ((car alist))
	      (execute-actions (cdr alist)))))
    (define (add-action! action)
      (begin (set! actions (cons action actions))
	     (action)
	     'ok))
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal)
	    ((eq? m 'set-signal!) set-signal!)
	    ((eq? m 'add-action!) add-action!)
	    (else (error "Unknown operation -- MAKE-WIRE" m))))
    dispatch))
(define (set-signal! wire new-value)
  ((wire 'set-signal!) new-value))
(define (get-signal wire)
  (wire 'get-signal))
(define (add-action! wire proc-of-no-arguments)
  ((wire 'add-action!) proc-of-no-arguments))
(define (inverter input output)
  (define (invert-input)
    (let ((new-value (logical-not (get-signal input))))
      (after-delay inverter-delay
		   (lambda () (set-signal! output new-value)))))
  (add-action! input invert-input) 'ok)
(define (logical-not s)
  (cond ((= s 0) 1)
        ((= s 1) 0)
	(else (error "Invalid signal" s))))
(define (and-gate a1 a2 output)
  (define (and-action-procedure)
    (let ((new-value
	    (logical-and (get-signal a1) (get-signal a2))))
      (after-delay
	and-gate-delay
	(lambda () (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a1 and-action-procedure)
  'ok)
(define (logical-and s1 s2)
  (cond ((not (and (or (= s1 1) (= s1 0)) (or (= s2 1) (= s2 0)))) ; Either s1 or s2 is neither 1 nor 0
	 (error "Invalid signal" (list s1 s2)))
        ((and (= s1 1) (= s2 1)) 1)
	(else 0)))
(define (or-gate o1 o2 output)
  (define (or-action-procedure)
    (let ((new-value
	    (logical-or (get-signal o1) (get-signal o2))))
      (after-delay
	or-gate-delay
	(lambda () (set-signal! output new-value)))))
  (add-action! o1 or-action-procedure)
  (add-action! o2 or-action-procedure)
  'ok)
(define (logical-or s1 s2)
  (cond ((not (and (or (= s1 1) (= s1 0)) (or (= s2 1) (= s2 0)))) ; Either s1 or s2 is neither 1 nor 0
	 (error "Invalid signal" (list s1 s2)))
        ((or (= s1 1) (= s2 1)) 1)
	(else 0)))
(define (after-delay delay action)
  (add-to-agenda! (+ delay (current-time the-agenda))
		  action
		  the-agenda))
(define (propagate)
  (if (empty-agenda? the-agenda)
      'done
      (let ((first-item (first-agenda-item the-agenda)))
	(first-item)
	(remove-first-agenda-item! the-agenda)
	(propagate))))
(define (probe name wire)
  (add-action! wire
	       (lambda ()
		 (newline)
		 (display name)(display " ")
		 (display (current-time the-agenda))
		 (display " New-value = ")
		 (display (get-signal wire)))))
(define (ripple-carry-adder an bn sn c-in)
  (if (and (null? an) (null? bn)) 
      sn
      (let ((c-out (make-wire))
	    (sum   (make-wire)))
	(begin (full-adder (car an) (car bn) c-in sum c-out)
	       (set! sn (cons sum sn))
	       (ripple-carry-adder (cdr an) (cdr bn) sn c-out)))))

(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok))

(define (full-adder a b c-in sum c-out)
  (let ((s (make-wire)) (c1 (make-wire)) (c2 (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))

(define (make-time-segment time queue)
  (cons time queue))
(define (segment-time s) (car s))
(define (segment-queue s) (cdr s))

(define (make-agenda) (list 0))
(define (current-time agenda) (car agenda))
(define (set-current-time! agenda time)
  (set-car! agenda time))
(define (segments agenda) (cdr agenda))
(define (set-segments! agenda segments)
  (set-cdr! agenda segments))
(define (first-segment agenda) (car (segments agenda)))
(define (rest-segments agenda) (cdr (segments agenda)))
(define (empty-agenda? agenda)
  (null? (segments agenda)))
(define (add-to-agenda! time action agenda)
  (define (belongs-before? segments)
    (or (null? segments)
	(< time (segment-time (car segments)))))
  (define (make-new-time-segment time action)
    (let ((q (make-queue)))
      (insert-queue! q action)
      (make-time-segment time q)))
  (define (add-to-segments! segments)
    (if (= (segment-time (car segments)) time)
	(insert-queue! (segment-queue (car segments))
		       action)
	(let ((rest (cdr segments)))
	  (if (belongs-before? rest)
	      (set-cdr!
		segments
		(cons (make-new-time-segment time action)
		      (cdr segments)))
	      (add-to-segments! rest)))))
  (let ((segments (segments agenda)))
    (if (belongs-before? segments)
	(set-segments!
	  agenda
	  (cons (make-new-time-segment time action)
		segments))
	(add-to-segments! segments))))
(define (remove-first-agenda-item! agenda)
  (let ((q (segment-queue (first-segment agenda))))
    (delete-queue! q)
    (if (empty-queue? q)
	(set-segments! agenda (rest-segments agenda)))))
(define (first-agenda-item agenda)
  (if (empty-agenda? agenda)
      (error "Agenda is empty: FIRST-AGENDA-ITEM")
      (let ((first-seg (first-segment agenda)))
	(set-current-time! agenda
			   (segment-time first-seg))
	(front-queue (segment-queue first-seg)))))

(define (make-queue) (cons '() '()))
(define (front-ptr queue) (car queue))
(define (rear-ptr  queue) (cdr queue))
(define (set-front-ptr! queue item)
  (set-car! queue item))
(define (set-rear-ptr! queue item)
  (set-cdr! queue item))
(define (empty-queue? queue)
  (null? (front-ptr queue)))
(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (car (front-ptr queue))))
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

(define the-agenda (make-agenda))
(define inverter-delay 2)
(define and-gate-delay 3)
(define or-gate-delay 5)
(define (test)
  (define input-1 (make-wire))
  (define input-2 (make-wire))
  (define sum (make-wire))
  (define carry (make-wire))
  (probe 'sum sum)
  (probe 'carry carry)
  (half-adder input-1 input-2 sum carry)
  (set-signal! input-1 1)
  (propagate))

(define (test2)
  (define input-1 (make-wire))
  (define input-2 (make-wire))
  (define and-out (make-wire))
  (probe 'and-out and-out)
  (and-gate input-1 input-2 and-out)
  (set-signal! input-1 1)
  (newline)
  (display "Now we change")
  (set-signal! input-1 0)
  (set-signal! input-2 1)
  (propagate))

; There would be an incorrect output if the procedures were added and removed at the front.
; In this example, if the inputs were evaluated last in, first out, the and gate would output 1 during a brief moment in time.