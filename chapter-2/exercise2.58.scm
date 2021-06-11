(define (deriv exp var)
  (display exp)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        (else
         (error "unknown expression type -- DERIV" exp))))

(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
	((and (number? a1) (number? a2)) (+ a1 a2))
	(else ((make-expression '+) a1 a2))))
  
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
	((=number? m1 1) m2)
	((=number? m2 1) m1)
	((and (number? m1) (number? m2)) (* m1 m2))
	(else ((make-expression '*) m1 m2))))

(define (sum? x)         (memq '+ x))
(define (product? x)     ((expression? '*) x))
(define (addend s)       ((before-sym  '+) s))
(define (augend s)       ((after-sym   '+) s))
(define (multiplier p)   ((before-sym  '*) p))
(define (multiplicand p) ((after-sym   '*) p))

(define (expression? s)
  (lambda (x) (and (pair? x) (eq? (cadr x) s))))

(define (before-sym s)
  (define (search exp)
    (if (eq? (car exp) s)
	()
	(cons (car exp) (search (cdr exp)))))
  (lambda (x) (one-or-list (search x))))

(define (after-sym s)
  (define (search exp)
    (if (eq? (car exp) s) 
	(one-or-list (cdr exp))
	(search (cdr exp))))
  (lambda (x) (search x)))

(define (one-or-list x)
  (if (= (length x) 1) (car x) x))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-expression s)
  (lambda (x y) (list x s y)))

(define (test)
  (deriv '(x + 3 * (x + y + 2)) 'x))
