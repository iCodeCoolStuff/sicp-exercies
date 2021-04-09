(define (fast-* a b)
  (cond ((= b 0) 0)
        ((= b 1) a)
        ((even? b) (fast-* (double a) (halve b)))
        (else (+ a (fast-* a (- b 1))))
  )
)

(define (double n)
  (* n 2)
)

(define (halve n)
  (/ n 2)
)


