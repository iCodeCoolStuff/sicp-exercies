(define (install-sparse-package)
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
        term-list
         (cons term term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (eq? term-list the-empty-termlist))
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))
  (define (make-sparse-polynomial var term-list)
    (cons (var term-list)))
  (define (term-list p) (cdr p))
  (define (variable  p) (car p))

  (define (tag-poly x) (cons 'sparse x))
  (define (tag-term x) (cons 'sparse-term x))
  (define (tag-list x) (cons 'sparse-list x))
  (put 'variable        'sparse      variable)
  (put 'make            'sparse-term (lambda (x y) (tag-term (make-term  x y))))
  (put 'first-term      'sparse-list (lambda (x)   (tag-term (first-term x))))
  (put 'rest-terms      'sparse-list (lambda (x)   (tag-list (rest-terms x))))
  (put 'term-list       'sparse-list (lambda (x)   (tag-list (term-list  x))))
  (put 'empty-termlist? 'sparse-list empty-termlist?)
  (put 'order           'sparse-term order)
  (put 'coeff           'sparse-term coeff)
  (put 'adjoin-term     '(sparse-term sparse-list) adjoin-term)
  (put 'make            'sparse (lambda (var term-list) (tag-poly (make-sparse-polynomial var term-list))))
'done)

(define (install-dense-package)
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
        term-list
         (cons term term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list)
    (let ((ord (- (length term-list) 1)))
      (make-term ord (car term-list) (enumerate-zero (- ord 1)))))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (eq? term-list the-empty-termlist))
  (define (make-term order coeff)
    (append (list coeff) (enumerate-zero (- order 1))))
  (define (order term) (- (length term) 1))
  (define (coeff term) (car term))
  (define (enumerate-zero n)
    (if (= n 0)
	'()
	(cons 0 (enumerate-zero (- n 1)))))
  (define (make-dense-polynomial var term-list)
    (cons (var term-list)))
  (define (term-list p) (cdr p))
  (define (variable  p) (car p))

  (define (tag-poly x) (cons 'dense x))
  (define (tag-term x) (cons 'dense-term x))
  (define (tag-list x) (cons 'dense-list x))
  (put 'variable        'dense       variable)
  (put 'make            'dense-term  (lambda (x y) (tag-term (make-term x y))))
  (put 'first-term      'dense-term  (lambda (x)   (tag-term (first-term x))))
  (put 'rest-terms      'dense-list  (lambda (x)   (tag-list (rest-terms x))))
  (put 'term-list       'dense-list  (lambda (x)   term-list)
  (put 'empty-termlist? 'dense-list  empty-termlist?)
  (put 'order           'dense-term  order)
  (put 'coeff           'dense-term  coeff)
  (put 'adjoin-term     '(dense-term dense-list) adjoin-term)
  (put 'make            '(variable   dense-list) (lambda (var term-list) (tag (make-dense-polynomial var term-list))))
'done)

(define (install-polynomial-package)
  (define (make-dense-polynomial variable term-list)
    ((get 'make 'dense) var terms))
  (define (make-sparse-polynomial variable term-list)
    ((get 'make 'sparse) var terms))
  (define (adjoin-term x term-list) (apply-generic 'adjoin-term x term-list))
  (define (variable p)  (apply-generic 'variable p))
  (define (term-list p) (apply-generic 'term-list p))
  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))
  (define (make-term var terms) (apply-generic 'make var terms)) 
  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (add-terms (term-list p1)
                              (term-list p2)))
        (error "Polys not in same var -- ADD-POLY"
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

  (define (tag x) (cons 'polynomial x))
  (put 'make-dense-polynomial  'polynomial (lambda (var terms) (tag (make-dense-polynomial var terms))))
  (put 'make-sparse-polynomial 'polynomial (lambda (var terms) (tag (make-sparse-polynomial var terms))))
'done)

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else
                         (error "No method for these types"
                                (list op type-tags))))))
              (error "No method for these types"
                     (list op type-tags)))))))