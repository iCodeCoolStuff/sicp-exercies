;               +---------------------+                                                                                       
;    global env:| a: (make-connector)-----------------------+                                                                 
;               | b: (make-connector)-----------------------|----------------------------+                                    
;               | set-value! ...      |                     |                            |                                    
;               +---------------------+                     |                            |                                    
;                   ^                                       |                            |                                    
;                   |                                       V                            V                                    
;               +--------------------+            +----------------------+     +----------------------+                        
;               | connector: a       |            | value: false         |     | value: false         |                       
;    set-value! | new-value: 10      |            | informant: false     |     | informant: false     |                       
;               | informant: 'user   |            | constraints: '()     |     | constraints: '()     |                       
;               +--------------------+            | set-my-value: ...    |     | set-my-value: ...    |                       
;                                                 | connect: ...         |     | connect: ...         |                       
;                                                 | forget-my-value: ... |     | forget-my-value: ... |                       
;                                                 | me: ...              |     | me: ...              |                       
;                                                 +----------------------+     +----------------------+                       
;               +--------------------+                     ^                                                                  
; set-my-value: | new-val: 10        |                     |                                                                  
;               | setter: 'user      |---------------------+                                                                  
;               +--------------------+                                                                                        
;                    ^  ^  ^                                                                                                       
;                    |  |  |                                                                                                       
;                    |  |  +----------------+                                                                                      
;                    |  +---------------+   |                                                                                      
;               +--------------------+  |   |                                                                                      
;         set!: | value: new-val     |  |   |                                                                                      
;               +--------------------+  |   |                                                                                      
;                                       |   |                                                                              
;               +--------------------+  |   |                                                                              
;         set!: | informant: setter  |--+   |                                                                              
;               +--------------------+      |                                                                              
;                                           |                                                  
;                                           |                                                                              
;                  +-------------------------------+                                                                       
; for-each-except: | exception: 'user              |                                                                       
;                  | procedure: inform-about-value |                                                                       
;                  | list: constraints             |                                                                       
;                  | loop: ...                     |                                                                       
;                  +-------------------------------+                                                                       
;                                ^                                                                                         
;                                |                                                                                         
;               +-----------+    |                                                                                         
;         loop: | list: '() |----+                                                                                         
;               +-----------+                                                                                              
