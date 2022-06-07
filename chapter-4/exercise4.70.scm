; The let binding's purpose is to provide an environment for the rest of the assertions. If the below code was used, then THE-ASSERTIONS would be an infinite stream of whatever
; assertion is (similar to the definition of ones in section 3.5.2).

(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (set! THE-ASSERTIONS
        (cons-stream assertion THE-ASSERTIONS))
  'ok)
