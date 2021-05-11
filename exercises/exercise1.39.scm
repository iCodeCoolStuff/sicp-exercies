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
