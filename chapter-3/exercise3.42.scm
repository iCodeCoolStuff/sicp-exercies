; This isn't safe. The serializer can't create more serialized procedures of the same set. Each deposit/withdraw
; operation are of different sets, so you could call 2 withdraw operations at the same time
; and get an incorrect value.
