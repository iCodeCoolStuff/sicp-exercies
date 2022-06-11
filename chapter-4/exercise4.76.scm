; The iterative version of this function is much cleaner
(define (unify-frames frame1 frame2)
  (cond ((null? frame1) frame2)
        ((null? frame2) frame1)
        (else
          (let* ((b1 (car frame1))
                 (b2 (car frame2))
                 (var1 (binding-variable b1))
                 (var2 (binding-variable b2))
                 (val1 (delay (binding-value b1)))
                 (val2 (delay (binding-value b2)))
                 (first (delay (binding-in-frame var1 (cdr frame2))))
                 (second  (delay (binding-in-frame var2 (cdr frame1)))))
            (cond ((equal? var1 var2)
                   (if (equal? (force val1) (force val2))
                       (let ((unify-result (unify-frames (cdr frame1) (cdr frame2))))
                         (if (eq? unify-result 'failed)
                             'failed
                             (cons b1 unify-result)))
                       'failed))
                  ((force first)
                   (unify-frames frame1 (cons (force first) (delete (force first) frame2))))
                  ((force second)
                   (unify-frames (cons (force second) (delete (force second) frame1)) frame2))
                  (else
                    (let ((unify-result (unify-frames (cdr frame1) (cdr frame2))))
                      (if (eq? unify-result 'failed)
                          'failed
                          (cons b1 (cons b2 unify-result))))))))))

; This will infinite-loop on (outranked-by ?x ?y) strictly due to evaluation order
; of the and clause
(define (superior-conjoin conjuncts frame-stream)
  (if (null? conjuncts)
      frame-stream
      (stream-flatmap
        (lambda (frame1)
          (stream-flatmap
            (lambda (frame2)
              (let ((unify-result (unify-frames frame1 frame2)))
                (if (eq? unify-result 'failed)
                    the-empty-stream
                    (singleton-stream unify-result))))
            (qeval (first-conjunct conjuncts) frame-stream)))
        (superior-conjoin (rest-conjuncts conjuncts) frame-stream))))

(put 'and 'qeval superior-conjoin)
