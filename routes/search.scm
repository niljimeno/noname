(define (route-search-songs body)
  (values (build-response #:code 200)
          (yt-dlp-search (get-json-value "query" body))))
