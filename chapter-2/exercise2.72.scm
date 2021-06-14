; Least frequent:

; Growth of steps required to search through a node for a symbol: n^2/2
; Growth of steps required to step through all nodes in the tree: n/2
; O(n/2 + n^2/2) = O(n^2)

; Most Frequent:
; Growth of steps required to search through node for the first symbol: 1
; Growth of steps required to step through all the nodes for the first node: 1

; This is for the special case. Let's assume all leaves have the same frequency

; Growth of steps required to search through node for the first symbol: 1
; Growth of steps required to step through nodes to the first node: log n
; O(log n)
