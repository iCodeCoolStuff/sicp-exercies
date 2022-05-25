(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))
(define articles '(article the a))
(define adjectives '(adjective red orange yellow green blue purple))
(define prepositions '(prep for to in by with))
(define adverbs      '(adverb slowly quickly steadily terribly))
(define conjunctions '(conj for and nor but or yet so))

(define *unparsed* '())
(define (parse input)
  (set! *unparsed* input)
  (let ((sent (parse-sentence)))
    (require (null? *unparsed*))
    sent))

(define (parse-sentence)
  (define (maybe-extend sentence)
    (amb sentence
	 (append sentence
		 (list (parse-word conjunctions))
		 (list (parse-noun-phrase))
		 (parse-verb-phrase))))
  (maybe-extend
    (list 'sentence
          (parse-noun-phrase)
          (parse-verb-phrase))))

(define (parse-simple-noun-phrase)
  (append (list 'simple-noun-phrase
                (parse-word articles))
                (maybe-parse-adjective-list)))

(define (maybe-parse-adjective-list)
  (define (maybe-add-adjective adjective-phrase)
    (amb (append adjective-phrase
		 (list (parse-word nouns)))
	 (maybe-add-adjective (append adjective-phrase
		                      (list (parse-word adjectives))))))
  (amb (list (parse-word nouns))
       (maybe-add-adjective (list (parse-word adjectives)))))
	      
(define (parse-verb-phrase)
  (define (maybe-append-adverb verb-list)
    (amb (maybe-append-adverb (append verb-list (list (parse-word adverbs))))
	 verb-list))
  (define (maybe-extend verb-phrase)
    (amb verb-phrase
	 (maybe-extend (list verb-phrase
			     (parse-prepositional-phrase)))))
  (maybe-extend (maybe-append-adverb (list 'verb-phrase (parse-word verbs)))))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (amb noun-phrase
	 (maybe-extend (list 'noun-phrase
			     noun-phrase
			     (parse-prepositional-phrase)))))
  (maybe-extend (parse-simple-noun-phrase)))

(define (parse-prepositional-phrase)
  (list 'prep-phrase
	(parse-word prepositions)
	(parse-noun-phrase)))

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (let ((found-word (car *unparsed*)))
    (set! *unparsed* (cdr *unparsed*))
    (list (car word-list) found-word)))
