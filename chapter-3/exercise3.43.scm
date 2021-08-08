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
;  |    a3 bal                                                                          
;  |    a1 bal                                                                          
;  |    calc diff                                                                  
;  |                  a1 bal                                                            
;  |                  a3 bal                                                            
;  |                  calc diff                                                    
;  |                  w1 diff                                                           
;  |                  d3 diff                                                           
;  |    w3 diff                                                                         
;  |    d1 diff                                                                         
;  |                                                                                    
;  |    a1            a2            a3                                                  
;  |                                                                                    
;  |    $50           $20           $10                                                 
;  |                                                                               
;  V                                                                               
;                                                                                  
;  time                                                                            
;                                                                                  
;  In this system, the first process is delayed while the second process completes. The first process can't withdraw
;  from a3 due to insufficient funds and $20 are created from the first process completing.
