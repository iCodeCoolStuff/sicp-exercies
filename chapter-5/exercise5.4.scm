; Iterative data-path diagram:                                                                                                                             
;                                _                                                                                                               
;                          0--->|=|                                                                                                              
;                                ^                                                                                                               
; +-----------+                  |                                                                                                               
; |  product  |                  |                                                                                                               
; +-----------+         +------>counter                                                                                                          
;   ^        | +---b    |        |                                                                                                                
;   |        | |        _        |   +----1                                                                                                       
;   _        v v       |x|       v   v                                                                                                            
;  |x|     +-----+      |      +-------+                                                                                                          
;   |       \ * /       |       \  -  /                                                                                                          
;   |        +-+        |        -----                                                                                                           
;   |      _  |         |      _   |                                                                                                             
;   +-r1<-|x|-+         +-r2<-|x|--+                                                                                                             
;                                                                                                                                          
;                                                                                                                                          
; Recursive data-path diagram:                                                                                                           
;                                                                                                                                          
;                   _                                                                                                                      
;                  |=|<---0                                                                                                      
;                   ^                                                                                                           
;                   |                                                                                                           
;          _      +---+           _        +-------+                                                                           
;     +---|x|-+   |   |----------|x|------>|       |                                                                            
;     |       |   | n |     _              | stack |                                                                            
;     |       |   |   |<---|x|-------------|       |                                                                             
;     |       |   +---+                    +-------+                                                                            
;     |       |     ^ ^                      |   ^                                                                              
;     |       |     | |                      |   |                                                                              
;     v       |     | |                      _   _                                                                              
;  +------+   |     | +-----------------+   |x| |x|                                                                             
;  | val  |   |     +---------+  +---+  |    |   |                                                                              
;  +------+   +--------+      |  |   |  |    v   |                                                                              
;    ^   |             |      v  v   |  _  +----------+                                                                        
;    |   |  +------+   |    +-----+  | |x| | continue |---> done                                                               
;    |   v  v      |   |     \ - /   |  |  +----------+                                                                          
;   |x| +-----+    |   |      +-+    |  |    ^     ^                                                                               
;    |   \ * /     |   |       |     |  |    |     |                                                                              
;    |    +-+      |   +----+  +-----|--+    _     _                                                                              
;    |     |       |        |        |      |x|   |x|                                                                             
;    +-----+       ^        ^        |       |     |                                                                                    
;                / b \    / 1 \------+       ^     ^                                                                                    
;               +-----+  +-----+           <___> <___>                                                                                   

; Iterative controller
(controller
 expt-iter
   (test (op =) (reg n) (const 0))
   (branch (label expt-finished))
   (assign r1 (op *) (reg product) (constant b))
   (assign r2 (op +) (reg counter) (constant 1))
   (assign product (reg r1))
   (assign counter (reg r2))
   (goto (label expt-iter))
 expt-finished)

; Recursive Controller
(controller
 (assign continue (label expt-done))
 expt-loop
   (test (op =) (reg n) (const 0))
   (branch (label base-case))
   (save continue)
   (save n)
   (assign n (op -) (reg n) (const 1))
   (assign continue (label after-fact))
   (goto (label expt-loop))
 after-fact
   (restore n)
   (restore continue)
   (assign val (op *) (const b) (reg val))
   (goto (reg continue))
 base-case
   (assign val (const 1))
   (goto (reg continue))
 expt-done)
