(rule (is-big-shot ?person)
      (and (job ?person (?division . ?_))
	   (supervisor ?someone ?person)
	   (not (supervisor ?person (job ?someone (?division . ?w))))))

