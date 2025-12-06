(define (route-not-found)
  (values (build-response #:code 404) "not found"))
