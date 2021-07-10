;                  +---------------------------------------+
;     global env:  | make-withdraw: ...                    |
;           +--------acc:                                  |
;           |      +---------------------------------------+
;           |                              ^
;           |               E1             |
;           |             +--------------------------------+
;           V             | balance: 100                   |<----------------------------+
;        (o)(o)---------->| withdraw: ...                  |                             |
;         |               | deposit:  ...                  |<----------------+           |
;         |               | dispatch: --+                  |                 |           |
;         V               +-------------|------------------+           E2    |           |
;         param: balance                |    ^                         +------------+    |
;         body: ...                     |    |                deposit: | amount: 40 |    |
;                                       V    |                         +------------+    |
;                                    (o)(o)--+                         E3                |
;                                     |                                +------------+    |
;                                     V                      withdraw: | amount: 60 |----+
;                                     param: m                         +------------+
;                                     body: ...
;
; 1. The local state for acc is kept in E1
; 2. Another environment, E4 is created that contains acc2's internal balance, deposit, withdraw, and dispatch procedures.
