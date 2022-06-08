; Doing interleave without delaying explicitly would continue to evaluate (flatten-stream (stream-cdr stream)) forever in some cases.
