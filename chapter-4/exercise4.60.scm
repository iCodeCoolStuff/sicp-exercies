; This happens because the query system looks for *all* variables ?person1 and ?person2 that satisfy lives-near.
; There is a way to find a list of people who live near each other in which pair appears only once, but the naive approach does not work. An example of a failed query is below.

(and (lives-near ?person1 ?person2)
     (not (lives-near ?person2 ?person1)))

; The above query does not work because it rules out all people who live near each other regardless of the order of the persons. The query ends up returning nothing.
; However, the below query does work.

(and (lives-near ?person1 ?person2)
     (not (lives-near ?person2 ?_)))

; This query rules out all possibilities where person2 is first. Therefore, no queries where both person1 and person2 are listed twice will appear.
