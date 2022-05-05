(sentence
  (simple-noun-phrase (article the) (noun professor))
  (verb-phrase
    (verb-phrase
      (verb-phrase (verb lectures)
                   (prep-phrase (prep to)
                                (simple-noun-phrase (article the) (noun student))))
      (prep-phrase (prep in) (simple-noun-phrase (article the) (noun class))))
    (prep-phrase (prep with) (simple-noun-phrase (article the) (noun cat)))))

(sentence
  (simple-noun-phrase (article the) (noun professor))
  (verb-phrase
    (verb-phrase (verb lectures)
                 (prep-phrase (prep to)
                              (simple-noun-phrase (article the) (noun student))))
    (prep-phrase (prep in)
                 (noun-phrase (simple-noun-phrase (article the) (noun class))
                              (prep-phrase (prep with)
                                           (simple-noun-phrase (article the) (noun cat)))))))

(sentence
  (simple-noun-phrase
    (article the) (noun professor))
  (verb-phrase
    (verb-phrase (verb lectures)
                 (prep-phrase (prep to)
                              (noun-phrase
                                (simple-noun-phrase
                                  (article the) (noun student))
                                (prep-phrase (prep in)
                                             (simple-noun-phrase
                                               (article the) (noun class))))))
    (prep-phrase (prep with)
                 (simple-noun-phrase
                   (article the) (noun cat)))))

(sentence
  (simple-noun-phrase
    (article the) (noun professor))
  (verb-phrase (verb lectures)
               (prep-phrase (prep to)
                            (noun-phrase
                              (noun-phrase
                                (simple-noun-phrase
                                  (article the) (noun student))
                                (prep-phrase (prep in)
                                             (simple-noun-phrase
                                               (article the) (noun class))))
                              (prep-phrase (prep with)
                                           (simple-noun-phrase (article the) (noun cat)))))))

(sentence
  (simple-noun-phrase
    (article the) (noun professor))
  (verb-phrase (verb lectures)
               (prep-phrase (prep to)
                            (noun-phrase
                              (simple-noun-phrase
                                (article the) (noun student))
                              (prep-phrase (prep in)
                                           (noun-phrase
                                             (simple-noun-phrase
                                               (article the) (noun class))
                                             (prep-phrase (prep with)
                                                          (simple-noun-phrase
                                                            (article the) (noun cat)))))))))

; 1. The professor lectures to the student with the class that has the cat in it.
; 2. The professor lectures to the student in the class that specifically has the cat.
; 3. The professor owns the cat and lectures to the student.
; 4. The professor lectures with the cat to the student.
; 5. The professor lectures to the student that owns the cat.
