(rule (is-grandson ?g ?s)
      (and (son ?f ?s))
           (son ?g ?f))

(rule (is-son ?m ?s)
      (and (wife ?m ?w)
           (son ?w ?s)))
