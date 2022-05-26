(rule (can-replace ?person1 ?person2)
      (or (same (job ?person1 ?job-p1) (job ?person2 ?job-p2))
	  (and (and (job ?someone ?job-p1) (job ?person1 ?job-p1))
	       (can-do-job ?someone ?job-p2))
	  (not (same ?person1 ?person2))))

; a)
(can-replace ?person (Fect Cy D))
; b)
(and (can-replace ?someone ?paid-more)
     (lisp-value > (salary ?paid-more ?x) (salary ?someone ?x)))
