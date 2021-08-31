; Louis's version fails because map uses the underlying scheme's version of apply instead of the one
; defined in the interpeter. This is evident when using a lambda function
; in the application of a primitive map. Eva's version works because map defined in the 
; interpreter uses the interpreter's version of apply instead of the underlying scheme's version of apply.
