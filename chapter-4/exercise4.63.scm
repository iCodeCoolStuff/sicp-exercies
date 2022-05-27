(rule (is-grandson ?s ?g)
      (and (son ?s ?f)
	   (son ?f ?g)))

(rule (is-son ?s ?m)
      (and (wife ?m ?w)
	   (son ?w ?s)))
