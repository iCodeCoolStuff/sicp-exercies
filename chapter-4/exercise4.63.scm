(rule (grandson ?g ?s)
      (and (son ?g ?f)
           (son ?f ?s)))

(rule (son ?m ?s)
      (and (wife ?m ?w)
           (son ?w ?s)))
