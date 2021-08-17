(define (sqrt-stream x)
  (cons-stream 1.0 (stream-map
                    (lambda (guess)
                      (sqrt-improve guess x))
                    (sqrt-stream x))))

(define (sqrt-stream x)
  (define guesses
    (cons-stream
      1.0
      (stream-map (lambda (guess) (sqrt-improve guess x))
                  guesses)))
  guesses)

; Louis's version of sqrt-stream has to compute the last guesses every time it wants to process a new guess. This is because
; sqrt-stream generates a new stream-map for each guess. The guesses version of sqrt-stream doesn't have this problem because
; stream-map always uses a new instance of guesses instead of building on top of all the old stream-maps.

; The two versions would not differ in efficiency after removing the memo because now both versions have to calculate the result
; of (sqrt-improve guess x) again.
