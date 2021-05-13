(define (compose f g) (lambda (x) (f (g x))))
(define (repeated f n)
  (define (rec i)
    (if (= i 1) (lambda (x) (f x)) (compose f (rec (- i 1)))))
  (rec n)) 

(define dx 0.00001)
(define (smooth f) 
  (lambda (x) (/ (+ (f (- x dx)) (f x) (f (+ x dx))) 3)))

(define (cubic a b c)
  (lambda (x) (+ (* x x x) (* a x x) (* b x) c)))

(define (test)
  (((repeated smooth 5) (cubic 5000 -1234 50)) 5.2345343))
  ; 130735.75943
