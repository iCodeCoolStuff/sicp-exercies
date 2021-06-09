(define (below-1 painter1 painter2)
  (let ((top-frame (transform-painter painter2
                     (make-vect 0 0.5)
                     (make-vect 1 0.5)
                     (make-vect 0 1)))
        (bottom-frame (transform-painter painter1
                     (make-vect 0 0)
                     (make-vect 1 0)
                     (make-vect 0 0.5))))
    (lambda (frame)
      (top-frame frame)
      (bottom-frame frame))))

(define (below-2 painter1 painter2)
  (rotate90 (beside (rotate270 painter1) (rotate270 painter2))))
