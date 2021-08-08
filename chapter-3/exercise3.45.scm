; The internal serializer only serializes the deposits and withdrawals inside of the one account. It does not
; serialize the deposits and withdrawals in the whole exchange procedure. It still allows for exchange to operate
; on ghost information. This is why the exchange procedure must be serialized and why the account serializer must be exposed. 
