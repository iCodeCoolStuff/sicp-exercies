(assert! (rule (same ?x ?x)))
(assert! (rule (lives-near ?person-1 ?person-2)
               (and (address ?person-1 (?town . ?rest-1))
                    (address ?person-2 (?town . ?rest-2))
                    (not (same ?person-1 ?person-2)))))
(assert! (rule (outranked-by ?staff-person ?boss)
               (or (supervisor ?staff-person ?boss)
                   (and (supervisor ?staff-person ?middle-manager)
                        (outranked-by ?middle-manager ?boss)))))

(assert! (rule (append-to-form () ?y ?y)))
(assert! (rule (append-to-form (?u . ?v) ?y (?u . ?z))
               (append-to-form ?v ?y ?z)))

(assert! (can-do-job (computer wizard) (computer programmer)))
(assert! (can-do-job (computer wizard) (computer technician)))
(assert! (can-do-job (computer programmer) (computer programmer trainee)))
(assert! (can-do-job (administration secretary) (administration big wheel)))

(assert! (rule (can-replace ?person1 ?person2)
               (and (and (job ?person1 ?job1)
			 (job ?person2 ?job2)
			 (or (same ?job1 ?job2)
			     (can-do-job ?job1 ?job2)))
                (not (same ?person1 ?person2)))))

; old working rule
(assert! (rule (outranked-by ?staff-person ?boss)
               (or (supervisor ?staff-person ?boss)
                   (and (supervisor ?staff-person ?middle-manager)
                        (outranked-by ?middle-manager ?boss)))))

(assert! (rule (is-big-shot ?person)
               (and (job ?person (?division . ?unused1))
		    (not (and (job ?someone (?division . ?unused2))
			      (outranked-by ?person ?someone))))))

(assert! (rule (meeting-time ?person ?day-and-time)
               (and (job ?person (?division . ?_))
		    (meeting ?division ?day-and-time))))

(assert! (rule (wheel ?person)
               (and (supervisor ?middle-manager ?person)
                    (supervisor ?x ?middle-manager))))

(assert! (rule (last-pair (?x . ()) (?x))))
(assert! (rule (last-pair (?x . ?y) ?z)
               (last-pair ?y ?z)))

(assert! (married Minnie Mickey))
(assert! (rule (married ?x ?y) (married ?y ?x)))

; This broken rule works thanks to the loop detector!
;(assert! (rule (outranked-by ?staff-person ?boss)
;      (or (supervisor ?staff-person ?boss)
;          (and (outranked-by ?middle-manager ?boss)
;               (supervisor ?staff-person ?middle-manager)))))

(assert! (rule (reverse () ())))
(assert! (rule (reverse (?x) (?x))))
(assert! (rule (reverse (?x . ?y) ?z)
               (and (reverse ?y ?w)
                    (append-to-form ?w (?x) ?z))))
(assert! (rule (reverse (?x . ?y) ?z)
               (and (append-to-form ?w (?x) ?z)
                    (reverse ?y ?w))))

(assert! (rule (grandson ?grandfather ?grandson)
               (and (son ?grandfather ?father)
                    (son ?father ?grandson))))

(assert! (rule (son ?m ?s)
               (and (wife ?m ?w)
                    (son ?w ?s))))

(assert! (rule ((grandson) ?x ?y) (grandson ?x ?y)))
(assert! (rule ((great . ?rel) ?x ?y)
               (and (?rel ?x ?z)
                    (son ?z ?y))))
