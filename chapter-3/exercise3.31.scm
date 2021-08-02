; This initialization is necessary because without the proc call, the wire simulation won't update/output its correct output
; In the half adder example, if one of the inputs was 1, the output would not be correct because there was no event to update
; the outputs based on the input.
