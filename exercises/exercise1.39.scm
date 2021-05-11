(define (tan-cf x k)
  (define (tan-cf-i i)
    (if (= i k) (/ (ex x i) (odd-nth i)) (/ (ex x i) (- (odd-nth i) (tan-cf-i (+ i 1)))))
  )
  (tan-cf-i 1)
)

(define (ex x i)
  (if (= i 1) x (square x)))

(define (odd-nth x)
  (+ 1.0 (* 2 (- x 1))))

(define (tan-cf-iter x k)
  (define (tan-i i result)
    (if (= i 0) result (tan-i (- i 1) (/ (ex x i) (- (odd-nth i) result))))
  )
  (tan-i k (/ (ex x k) (odd-nth k)))
)

(define (test)
  (tan-cf-iter 2 10)
)
