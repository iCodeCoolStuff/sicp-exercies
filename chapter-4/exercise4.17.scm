;          +---------+
;  global: |         |
;          +---------+
;           ^
;           |
;          +---------+
; lambda   | <vars>  |
; (u v):   +---------+
;           ^
;           |
;          +------------------+
;          | u: '*unassigned* |
;          | v: '*unassigned* |
;          +------------------+
;                       ^ ^ ^
;                       | | |
;          +---------+  | | |
;          | u: <e1> |--+ | |
;          +---------+    | |
;                         | |
;          +---------+    | |
;          | u: <e1> |----+ |
;          +---------+      |
;                           |
;          +------+         |
;          | <e3> |---------+
;          +------+
;
; 1. There is an extra frame because of the let statement with unassigned variables.
; 2. This statement cannot make a difference because the environment structure does not
;    change the output of the program.
; 3. Append u and v to vars of the lambda and append two '*unassigned* symbols to the list of parameters when evaluating lambda.
;    Insert two assignments to the beginning of the lambda body to set the unassigned variables.
