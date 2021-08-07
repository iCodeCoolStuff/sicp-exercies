;  With these processes run sequentially, the account balances should be $10, $20, 30 in some order. This should be obvious,
;  so I will not explain it here. However, if exchange is executed in parallel, things could get problematic as shown below.
;                                                                                  
;  |    a1            a2            a3                                                  
;  |                                                                                    
;  |    $10           $20           $30                                                 
;  |                                                                                    
;  |                                                                                    
;  |    Paul          Peter                                                             
;  |                                                                                    
;  |    a1 bal                                                                          
;  |    a2 bal                                                                          
;  |                  a1 bal                                                            
;  |    w1 diff                                                                         
;  |                  a3 bal                                                            
;  |    d2 diff                                                                         
;  |                  w1 diff                                                           
;  |                  d3 diff                                                           
;  |                                                                                    
;  |    a1            a2            a3                                                  
;  |                                                                                    
;  |    $40           $10           $10                                                 
;  |                                                                               
;  V                                                                               
;                                                                                  
;  time                                                                            
;                                                                                  
; In the previous example, the sum of the accounts was preserved, so theoretically, we should be able to use this code
; without destroying or creating cash out of thin air, right?
; 
;  |    a1            a2            a3                                                  
;  |                                                                                    
;  |    $10           $20           $30                                                 
;  |                                                                                    
;  |                                                                                    
;  |    Paul          Peter                                                             
;  |                                                                                    
;  |    a1 bal                                                                          
;  |    a2 bal                                                                          
;  |    calc diff                                                                  
;  |    w1 diff                                                                         
;  |                  a1 bal                                                            
;  |                  a3 bal                                                            
;  |                  calc diff                                                    
;  |    d2 diff                                                                         
;  |                  w1 diff                                                           
;  |                  d3 diff                                                           
;  |                                                                                    
;  |    a1            a2            a3                                                  
;  |                                                                                    
;  |    $50           $20           $-10                                                
;  |                                                                               
;  V                                                                               
;                                                                                  
;  time                                                                            
;                                                                                  
;  Presumably, the system would raise an error and respond with "Insufficient funds" if another swap was made between a3
;  and any other account. Essentially this creates 10 dollars.

; However, if negative dollars are counted, then this system will always preserve the sum of the dollars of the account, provided
; no one ever tries to exchange dollars between accounts with negative values.
