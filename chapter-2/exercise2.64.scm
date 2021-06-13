; a

; First, the program allocates (n-1)/2 elements to the left part of the tree. The program constructs the left result from the
; allocated space and fetches the left tree. The right size is allocated from the size (n - (left-size + 1)). 
; The current entry from the tree is fetched from the non-left elements. The right result is constructed from the right size 
; and non-left elements. The right tree is retrieved from the right result. Fianally, the tree is 
; constructed from the left tree, the right tree, and the current entry.

; b

; The order of growth is Theta(n).
