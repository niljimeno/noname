(define (get-json-value val body)
  (let ((json (json-string->scm (utf8->string body))))
    (cdr (assoc val json))))
