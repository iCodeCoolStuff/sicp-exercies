; exercise 5.26:

; a)

(factorial 7)
maximum-depth = 35

; b)

factorial n | # of pushes
---------------------------
     0      | 33
     1      | 70
     2      | 107
     3      | 144
     4      | 181
     5      | 218
     6      | 255
     7      | 292

total_pushes(n) = 33 + 37(n) = O(n)

; exercise 5.27:

factorial n | # of pushes - iterative | # of pushes - recursive
--------------------------------------------------------------
     0      | 33                      | -
     1      | 70                      | 18
     2      | 107                     | 52
     3      | 144                     | 86
     4      | 181                     | 120
     5      | 218                     | 154
     6      | 255                     | 188
     7      | 292                     | 222

factorial n | maximum depth - iterative | maximum depth - recursive
--------------------------------------------------------------
     0      | 14                        | -
     1      | 17                        | 11
     2      | 20                        | 19
     3      | 23                        | 27
     4      | 26                        | 35
     5      | 29                        | 43
     6      | 32                        | 51
     7      | 35                        | 59
