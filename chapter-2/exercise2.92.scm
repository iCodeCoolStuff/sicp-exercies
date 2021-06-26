(define (=zero? x)
  (cond ((number? x) (= x 0))
        ((polynomial? x) (empty-termlist? x))
	(else (error "Invalid type -- =ZERO?" x))))

(define (expand poly)
  (make-poly (variable poly) (expand-terms (term-list poly))))

(define (expand-terms tlist)
  (define (ex term)
    (if (polynomial? (coeff term))
        (let ((sub-poly (coeff term)))
	     (map (lambda (x) (make-term (order term) (make-poly (variable sub-poly) (list x)))) (expand-terms (term-list sub-poly))))
	(list term)))
  (flatmap ex tlist))

(define (flatmap proc lst)
  (if (null? lst)
      '()
      (append (proc (car lst)) (flatmap proc (cdr lst)))))

(define (filter pred lst)
  (cond ((null? lst) '())
        ((pred (car lst)) (cons (car lst) (filter pred (cdr lst))))
	(else (filter pred (cdr lst)))))

(define (adjoin-term term term-list)
  (if (=zero? (coeff term))
      term-list
      (cons term term-list)))
(define (tag-polynomial x) (cons 'polynomial x))
(define (the-empty-termlist) '())
(define (first-term term-list) (car term-list))
(define (rest-terms term-list) (cdr term-list))
(define (empty-termlist? term-list) (null? term-list))
(define (make-term order coeff) (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))
(define (make-poly variable term-list)
  (if (null? term-list)
      (error "Cannot make polynomial with an empty term-list -- MAKE-POLY" (list variable term-list))
  (tag-polynomial (cons variable term-list))))
(define (variable? x) (symbol? x))
(define (same-variable? x y)
  (and (variable? x) (variable? y) (eq? x y)))
(define (variable poly)
  (car (contents poly)))
(define (term-list poly)
  (cdr (contents poly)))

(define (add-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (add-terms (term-list p1)
                              (term-list p2)))
        (error "Polys not in same var -- ADD-POLY"
               (list p1 p2))))

(define (mul-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
                 (mul-terms (term-list p1)
                            (term-list p2)))
      (error "Polys not in same var -- MUL-POLY"
             (list p1 p2))))

(define (add-terms L1 L2)
  (cond ((empty-termlist? L1) L2)
        ((empty-termlist? L2) L1)
        (else
         (let ((t1 (first-term L1)) (t2 (first-term L2)))
           (cond ((> (order t1) (order t2))
                  (adjoin-term
                   t1 (add-terms (rest-terms L1) L2)))
                 ((< (order t1) (order t2))
                  (adjoin-term
                   t2 (add-terms L1 (rest-terms L2))))
                 (else
                  (adjoin-term
                   (make-term (order t1)
                              (add (coeff t1) (coeff t2)))
                   (add-terms (rest-terms L1)
                              (rest-terms L2)))))))))

(define (mul-terms L1 L2)
  (if (empty-termlist? L1)
      (the-empty-termlist)
      (add-terms (mul-term-by-all-terms (first-term L1) L2)
                 (mul-terms (rest-terms L1) L2))))

(define (mul-term-by-all-terms t1 L)
  (if (empty-termlist? L)
      (the-empty-termlist)
      (let ((t2 (first-term L)))
        (adjoin-term
         (make-term (+ (order t1) (order t2))
                    (mul (coeff t1) (coeff t2)))
         (mul-term-by-all-terms t1 (rest-terms L))))))

(define (coerce-to-polynomial var x)
  (make-poly var (list (make-term 0 x))))

(define (add a1 a2)
  (cond ((and (eq? (type a1) 'number)     (eq? (type a2) 'polynomial)) (add (coerce-to-polynomial (variable a2) a1) a2))
        ((and (eq? (type a1) 'polynomial) (eq? (type a2) 'number))     (add a1 (coerce-to-polynomial (variable a1) a2)))
        ((eq? (type a1) 'number) (+ a1 a2))
        ((and (polynomial? a1) (polynomial? a2)) (add-poly a1 a2))
	(else (error "Invalid type -- ADD" a1 a2))))

(define (mul m1 m2)
  (cond ((and (eq? (type m1) 'number)     (eq? (type m2) 'polynomial)) (mul (coerce-to-polynomial (variable m2) m1) m2))
        ((and (eq? (type m1) 'polynomial) (eq? (type m2) 'number))     (mul m1 (coerce-to-polynomial (variable m1) m2)))
       ; ((not (eq? (type m1) (type m2))) (error "Types of m1 and m2 are different -- MUL" m1 m2))
        ((eq? (type m1) 'number) (* m1 m2))
        ((and (polynomial? m1) (polynomial? m2)) (mul-poly m1 m2))
	(else (error "Invalid type -- MUL" m1 m2))))

(define (polynomial? x) 
  (and (pair? x) (eq? (car x) 'polynomial)))
(define (type x)
  (cond ((number? x) 'number)
        ((polynomial? x) 'polynomial)
        (else (error "Invalid type -- TYPE" x))))
(define (contents x)
  (if (number? x)
      x
      (cdr x)))

(define (test)
  (define polya (make-poly 'x (list (make-term 2 (make-poly 'y (list (make-term 1 1) (make-term 0 1))))
				   (make-term 1 (make-poly 'y (list (make-term 2 1) (make-term 0 1))))
				   (make-term 0 (make-poly 'y (list (make-term 1 1) (make-term 0 -1)))))))
  (define poly (make-poly 'x (list (make-term 1 (make-poly 'y (list (make-term 2 1) (make-term 1 1) (make-term 0 1)))))))
  (expand poly))

(define (test2)
  (make-poly 'x (list (make-term 2 1) (make-term 1 2) (make-term 0 1))))

(define (test3)
  (make-poly 'x (list (make-term 0 (make-poly 'y (list (make-term 0 1)))))))

(define (test4)
  (make-poly 'x (list (make-term 2 1) (make-term 1 (make-poly 'y (list (make-term 1 5) (make-term 0 1)))) (make-term 0 1))))
