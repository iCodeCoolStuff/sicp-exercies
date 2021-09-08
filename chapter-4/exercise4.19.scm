; I support Eva's perspective because it allows the language to be more flexible in terms of definitions.

; One way of implementing internal definitions the way Eva prefers is to delay evaluation of
; incomplete definitions (i.e. those defined in terms of variables that haven't been defined yet)
; and then completing those definitions once the defined variables have been found. This process
; would signal an error if two or more definitions depend on each other.
