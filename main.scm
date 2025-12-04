(add-to-load-path "/usr/local/share/guile/site/3.0/")

(use-modules (json)
             (web request)
             (web response)
             (web uri)
             (ice-9 binary-ports)
             (ice-9 threads)
             (ice-9 i18n)
             (fibers)
             (fibers web server)
             (rnrs bytevectors)
             (srfi srfi-1))

(load "shell.scm")


(define (handler request body)
  (let ((url (uri-path (request-uri request))))
    (let ((main-section (first (url-sections url))))
      (cond
       ((equal? main-section "song")
        (route-download-song body))
       ((equal? main-section "search")
        (route-search-songs body))
       (else (route-not-found))))))


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
      (clean-existing (cdr (assoc 'filepath song-data)))
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

(define (route-search-songs body)
  (values (build-response #:code 200)
          (yt-dlp-search (get-json-value "query" body))))


(define (route-not-found)
  (values (build-response #:code 404) "not found"))


(define (url-sections url)
  (drop (string-split url #\/) 1))


(define (get-json-value val body)
  (let ((json (json-string->scm (utf8->string body))))
    (cdr (assoc val json))))


(define (yt-dlp-download yt-url path)
  (run-command (command-append
                "yt-dlp"
                "-x"
                "--extract-audio"
                "-o"
                path
                yt-url)))


(define (yt-dlp-search query)
  (run-command (command-append
                "yt-dlp"
                (string-append "ytsearch5:"
                               (string-append "\"" query "\""))
                "--get-id"
                "--get-title"
                "--no-warnings")))


(define (setup)
  (run-command (command-append "mkdir" "-p" "target")))

(define main
  ((setup)
   (run-server handler #:host "0.0.0.0" #:port 8080)))
