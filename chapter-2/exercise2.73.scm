; a
; The sum? and product? predicates were removed. Instead, the dispatch table decides what operation to perform based on
; the operator. number? and same-variable? can't be moved into the dispatch because they have operator symbol or "type tag."

; b

(define (install-sum-and-product-package)
  (define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get 'deriv (operator exp)) (operands exp)
                                            var))))
  (define (operator exp) (car exp))
  (define (operands exp) (cdr exp))
  (define (deriv-sum ops var)
    (make-sum (deriv (addend ops) var)
	      (deriv (augend ops) var)))

  (define (deriv-product ops var)
    (make-sum 
      (make-product (multiplier ops)
		    (deriv (multiplicand ops) var))
      (make-product (multiplicand ops)
		    (deriv (multiplier ops) var))))
  (put 'deriv '+ deriv-sum)
  (put 'deriv '* deriv-product)
  'done)

; c

(define (install-sum-and-product-package)
  (define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get 'deriv (operator exp)) (operands exp)
                                            var))))
  (define (operator exp) (car exp))
  (define (operands exp) (cdr exp))
  (define (deriv-sum ops var)
    (make-sum (deriv (addend ops) var)
	      (deriv (augend ops) var)))
  (define (deriv-product ops var)
    (make-sum 
      (make-product (multiplier ops)
		    (deriv (multiplicand ops) var))
      (make-product (multiplicand ops)
		    (deriv (multiplier ops) var))))
  (define  (deriv-exponent ops var)
    (make-product
      (make-product
	(exponent ops)
	(make-exponentiation (base ops) (- (exponent ops) 1)))
      (deriv (base ops) var)))
  (put 'deriv '+ deriv-sum)
  (put 'deriv '* deriv-product)
  (put 'deriv '^ deriv-exponent)
  'done)

; d
; Only the put method  would need to be changed. The derivative procedure or other procedures would not need to be changed
; at all.
