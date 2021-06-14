; N = 5
; (((((leaf a 1) (leaf b 2) (a b) 3) (leaf c 4) (a b c) 7) (leaf d 8) (a b c d) 15) (leaf e 16) (a b c d e) 31)
;      31 
;      / \  
;     /   \  
;    /     \  
;  (E 16)   15 
;          / \
;         /   \
;        /     \
;      (D 8)    \
;                7
;               / \
;              /   \
;             /     \
;           (C 4)    3
;                   / \
;                  /   \
;                 /     \
;               (B 2)  (A 1) 
;
; N = 10
;((((((((((leaf a 1) (leaf b 2) (a b) 3) (leaf c 4) (a b c) 7) (leaf d 8) (a b c d) 15) (leaf e 16) (a b c d e) 31) (leaf f 32) (a b c d e f) 63) (leaf g 64) (a b c d e f g) 127) (leaf h 128) (a b c d e f g h) 255) (leaf i 256) (a b c d e f g h i) 511) (leaf j 512) (a b c d e f g h i j) 1023)
;
;        1023
;        /  \
;       /    \
;      /      \
;   (J 512)   511
;             / \
;            /   \
;           /     \
;       (I 256)   255
;                 / \
;                /   \
;               /     \
;            (H 128)  127
;                     / \
;                    /   \
;                   /     \
;                (G 64)   63
;                        /  \
;                       /    \
;                      /      \
;                    (F 32)   31
;                            /  \
;                           /    \
;                          /      \
;                       (E 16)    15
;                                /  \
;                               /    \
;                              /      \
;                            (D 8)     7
;                                     / \
;                                    /   \
;                                   /     \
;                                 (C 4)    3
;                                         / \
;                                        /   \
;                                       /     \
;                                    (B 2)   (A 1)
;

; In General, the least frequent symbol takes n-1 bits to encode and the most frequent symbol takes 1 bit to encode.
