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

(define make-account-number
  (let ((prev-number 0))
    (lambda ()
      (set! prev-number (+ prev-number 1))
            prev-number)))

(define (make-account-and-serializer balance)
  (let ((account-number (make-account-number)))
    (define (withdraw amount)
      (if (>= balance amount)
      (begin (set! balance (- balance amount))
              balance)
    "Insufficient funds"))
    (define (deposit amount)
      (set! balance (+ balance amount))
            balance)
    (let ((balance-serializer (make-serializer)))
      (define (dispatch m)
        (cond ((eq? m 'withdraw) withdraw)
              ((eq? m 'deposit)    deposit)
              ((eq? m 'balance)    balance)
              ((eq? m 'acc-number) account-number)
              ((eq? m 'serializer) balance-serializer)
              (else (error "Unknown request: MAKE-ACCOUNT" m))))
  dispatch)))

(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
	(serializer2 (account2 'serializer)))
    ((serializer1 (serializer2 exchange))
     account1
     account2)))

(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
		       (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))

(define (new-serialized-exchange account1 account2)
  (define (pair-accs-by-number acc1 acc2)
    (if (< (acc1 'acc-number) (acc2 'acc-number))
	(cons acc1 acc2)
	(cons acc2 acc1)))
  (let ((acc-pair (pair-accs-by-number account1 account2)))
    (let ((serializer1 ((car acc-pair) 'serializer))
	  (serializer2 ((cdr acc-pair) 'serializer)))
      ((serializer2 (serializer1 exchange))
       account1
       account2))))

; new-serialized-exchange avoids the deadlock problem because exchange isn't waiting on another account's serializer to finish
; before starting a new exchange procedure. Let's say Peter tries to exchange a1 and a2 at the same time Paul tries to exchange
; a2 and a1. Peter's exchange procedure is protected by a2's serializer and a1's serializer in that order. Paul's exhange
; procedure is the reverse. When Peter calls his exchange procedure, it is protected by a1's serializer and a2's serializer in
; that order. Now let's interleave the mutex acquisition of both Paul's and Peter's exchange procedures. First, Peter
; acquires a1. Then Paul acquires a2. Next, Peter tries to acquire a1, but it is currently acquired by Paul. 
; Then Paul tries to acquire a2, but a2 is currently acquired by Peter. This results in a deadlock where both Paul and Peter 
; are waiting on the other to release the mutex.

; In the new-serialized-exchange procedure, both Peter and Paul acquire a1 and a2 in that order. First, Peter acquires a1. Next,
; Paul tries to acquire a1, but he is blocked by Peter's procedure. Peter then acquires a2 and then finishes his exchange
; procedure. Finally, Paul acquires both a1 and a2 and finishes his exchange procedure.
