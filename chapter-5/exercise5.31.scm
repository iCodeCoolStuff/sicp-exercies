; 1) (f 'x 'y)
; 
; save and restore operations are not needed here
; 
; 2) ((f) 'x 'y)
; 
; save and restore are superfluous around 'x and 'y but not (f) since (f) is a procedure application
; 
; 3) (f (g 'x) y)
; 
; save and restore is superfluous inside of (g 'x) but not outside of (g 'x)
; 
; 4) (f (g 'x) 'y)
; 
; save and restore is superfluous around 'y
