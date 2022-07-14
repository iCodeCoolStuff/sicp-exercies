; Insert the following lines of code in their respective locations within ch5-eceval

 (define eceval-operations
   (list
    ;;primitive Scheme operations
                 
    ...
    (list 'cond? cond?)
    (list 'cond->if cond->if)
    ...)
   (test (op cond?) (reg exp))
   (branch (label ev-cond))
 ev-cond
   (assign exp (op cond->if) (reg exp))
   (goto (label ev-if))
   ...)
