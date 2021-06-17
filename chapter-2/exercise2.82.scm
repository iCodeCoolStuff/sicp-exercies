(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
	  (apply proc (map contents args))
	  (let ((first-type (car type-tags))
		(type-list (map (lambda (x) first-type) type-tags))
		(new-proc (get op type-list)))
	    (if new-proc
              (apply-generic op (map (lambda (element) (coerce-element (type-tag (car args)) element)) (cdr args)))
	      (error "No generic operation for several args (op type)" op first-type)))))))

(define (coerce-element type element)
  (let ((element-type (type-tag element))
	(coercion (get-coercion element-type type)))
    (if coercion
	(coercion element)
	(error "No coercion for type->type" element-type type))))
