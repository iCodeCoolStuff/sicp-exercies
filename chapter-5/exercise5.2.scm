(data-paths
 (registers
  ((name product)
   (buttons ((name t1<-product) (source (operation *)))))
  ((name counter)
   (buttons ((name t2<-counter) (source (operation +)))))
  ((name t1)
   (buttons ((name product<-t1) (source (register t1)))))
  ((name t2)
   (buttons ((name counter<-t2) (source (register t2))))))

 (operations
  ((name *)
   (inputs (register product) (register counter)))
  ((name +)
   (inputs (register counter) (constant 1)))
  ((name >)
   (inputs (register counter) (constant n)))))

(controller
 test-gt
   (test >)
   (branch (label factorial-done))
   (t1<-product)
   (product<-t1)
   (t2<-counter)
   (counter<-t2)
   (goto (label test-gt))
 factorial-done)
