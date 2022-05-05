; This does not work because (parse-word) requires that the *unparsed* global variable is not null.
; If the order was switched in the amb, the program would never terminate because it would always call
; parse-verb-phrase
