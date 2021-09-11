; All measurements are done with a stopwatch

; Fibonacci Sequence

(define (fib n)
  (cond ((= n 0) 0)
	((= n 1) 1)
	(else (+ (fib (- n 1)) (fib (- n 2))))))

; (fib 21)
; Analyzed version: 3.68 seconds
; Non-analyzed version: 6.55 seconds

(define (countdown n)
  (if (= n 0) 'done (countdown (- n 1))))

; (countdown 100000)
; Analyzed version: 6.34 seconds
; Non-analyzed version: 6.35 seconds

(define (sumdown n)
  (if (= n 0) 0 (+ n (sumdown (- n 1)))))

; (sumdown 50000)
; Analyzed version: 4.52 seconds
; Non-analyzed version: 4.51 seconds

(define (tryit n)
  (let ((a 1)
	(b 2))
    (if (= n 0)
	n
	(+ a b (tryit (- n 1))))))

; (tryit 30000)
; Analyzed version: 3.92 seconds
; Non-analyzed version: 6.74 seconds
