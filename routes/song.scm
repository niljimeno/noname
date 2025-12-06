(define (name-from-song-url url)
  (number->string (random 999)))

(define (get-song-data url)
  (let ((name (name-from-song-url url)))
    `((name . "alex-putero")
      (filename . ,(string-append name ".opus"))
      (outpath . ,(string-append "target/" name))
      (filepath . ,(string-append "target/" name ".opus"))
      (url . ,url))))

(define (route-download-song body)
  (let ((song-url (get-json-value "url" body)))
    (let ((song-data (get-song-data song-url)))
      (yt-dlp-download (cdr (assoc 'url song-data))
                       (cdr (assoc 'outpath song-data)))
      (let ((content (call-with-input-file
                      (cdr (assoc 'filepath song-data))
                      get-bytevector-all)))
        (values (build-response
                 #:headers `((content-type . (application/octet-stream))
                             (content-disposition . (attachment
                                                     (filename . ,(cdr (assoc 'filename song-data)))))))
                content)))))
