; a)
; Option 1: Peter, Paul, Mary -> $45
; Option 2: Peter, Mary, Paul -> $35
; Option 3: Paul, Peter, Mary -> $45
; Option 4: Paul, Mary, Peter -> $50
; Option 5: Mary, Peter, Paul -> $40
; Option 6: Mary, Paul, Peter -> $40
; 
; b)
; 1. The account could have its balance set to $50 because Mary could be the last one to set the balance.
; 2. The account could have its balance set to $80 because Paul could be the last one to set the balance.
;                                                                                                                                   
; 1.                                                                                                                                
;                                                                                                                                   
;    Peter                    Paul                    Mary                    Bank                                                  
;                                                                                                                                   
;                                                                             $100                                                  
;    Access: $100                                                                                                                   
;                                                     Access: $100                                                                  
;                             Accees: $100                                                                                          
;    New-value: 100+10=110                                                                                                          
;                                                     New-value: 100/2=50                                                           
;                             New-value: 100-20=80                                                                                  
;    set! balance to $110                                                     $110                                                  
;                                                     set! balance to $50     $50                                                   
;                             set! balance to $80                             $80                                                   
;                                                                                                                                   
; 2.                                                                                                                                
;                                                                                                                                   
;    Peter                    Paul                    Mary                    Bank                                                  
;                                                                                                                                   
;                                                                             $100                                                  
;                                                     Access: $100                                                                   
;                             Access: $100                                                                                          
;    Access: $100                                                                                                                   
;                                                     New-value: 100/2=50                                                           
;                             New-value: 100-20=80                                                                                  
;    New-value: 100+10=110                                                                                                          
;                                                     set! balance to $50     $50                                                   
;                             set! balance to $80                             $80                                                   
;    set! balance to $110                                                     $110                                                  
