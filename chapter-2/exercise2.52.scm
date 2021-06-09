; a
(define wave (segments->painter
  (list
    (make-segment
      (make-vect 0.15 0)
      (make-vect 0.39 0.47))
    (make-segment
      (make-vect 0.39 0.47)
      (make-vect 0.3  0.62))
    (make-segment
      (make-vect 0.3  0.62)
      (make-vect 0.11 0.45))
    (make-segment
      (make-vect 0.11 0.45)
      (make-vect 0    0.64))
    (make-segment
      (make-vect 0 0.75)
      (make-vect 0.15 0.62))
    (make-segment
      (make-vect 0.15 0.62)
      (make-vect 0.33 0.7))
    (make-segment
      (make-vect 0.33 0.7)
      (make-vect 0.43 0.7))
    (make-segment
      (make-vect 0.43 0.7)
      (make-vect 0.33 0.86))
    (make-segment
      (make-vect 0.33 0.86)
      (make-vect 0.44 1))
    (make-segment
      (make-vect 0.59 1)
      (make-vect 0.69 0.84))
    (make-segment
      (make-vect 0.69 0.84)
      (make-vect 0.62 0.7))
    (make-segment
      (make-vect 0.62 0.7)
      (make-vect 0.77 0.69))
    (make-segment
      (make-vect 0.77 0.69)
      (make-vect 1 0.47))
    (make-segment
      (make-vect 1 0.2)
      (make-vect 0.65 0.42))
    (make-segment
      (make-vect 0.65 0.42)
      (make-vect 0.8 0))
    (make-segment
      (make-vect 0.7 0)
      (make-vect 0.48 0.3))
    (make-segment
      (make-vect 0.48 0.3)
      (make-vect 0.32 0))
    (make-segment
      (make-vect 0.45 0.9)
      (make-vect 0.45 0.85))
    (make-segment
      (make-vect 0.55 0.9)
      (make-vect 0.55 0.85))
    (make-segment
      (make-vect 0.45 0.8)
      (make-vect 0.5 0.78))
    (make-segment
     (make-vect 0.5 0.78)
     (make-vect 0.55 0.8)))))

; b
(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left up)
              (bottom-right right)
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))
; c
(define (square-limit painter n)
  (let ((quarter (rotate180 (corner-split painter n))))
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))
