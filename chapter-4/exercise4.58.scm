(rule (is-big-shot ?person)
      (and (job ?person (?division . ?unused1))
           (not (and (job ?someone (?division . ?unused2))
      	       (outranked-by ?person ?someone)))))

