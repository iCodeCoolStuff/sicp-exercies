; Generic Operations with explicit dispatch:
; In order to add new types, a new type check and a new type-specific operation must be added to the generic function
;
; Data-Directed Style: 
; When adding a new type, a new operation for every distinct operation in the table must be constructed. When adding a new operation,
; an operation that works on each type in the table must be constructed.
;
; Adding new types is only as difficult as adding new operations for that type and vice versa.
;
; Message passing:
; When a new type is introduced, a new check for each type must be added to each generic operation. However, when a new operation
; is introduced, it must have check for each type it will operate on.
;
;
; For a system where new types must often be added, explicit dispatch is optimal because relatively few functions keep track
; of the number of types to check. For a system where new operations must be added, message passing is optimal. New operations
; have relatively few type checks and new procedures don't interfere with the representation of new types.
