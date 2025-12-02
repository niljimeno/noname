(use-modules (web request)
             (web response)
             (web uri)
             (ice-9 binary-ports)
             (ice-9 threads)
             (ice-9 i18n)
             (fibers)
             (fibers web server)
             (srfi srfi-1))

(load "shell.scm")


(define (handler request body)
  (let ((url (uri-path (request-uri request))))
    (let ((main-section (first (url-sections url))))
    (cond
     ((equal? main-section "song")
      (route-download-song request))
     ((equal? main-section "search")
      (route-search-songs request))))))

(define (route-download-song request)
  (let* ((yt-url (string-append
                  "https://www.youtube.com/watch?v="
                  (get-param request "url")))
         (id (number->string (random 999)))
         (filename (string-append id ".opus"))
         (path (string-append "target/" id)))
    (yt-dlp-download yt-url path)
    (let ((content (call-with-input-file
                    (string-append "target/" filename)
                    get-bytevector-all)))
      (values (build-response
               #:headers `((content-type . (application/octet-stream))
                           (content-disposition . (attachment (filename . ,filename)))))
              content))))

(define (route-search-songs request)
  (values (build-response #:code 200)
          (yt-dlp-search (get-param request "q"))))


(define (url-sections url)
  (drop (string-split url #\/) 1))

(define (get-param request param)
  (let ((params (uri-query (request-uri request))))
    (and params
         (let ((pairs (string-split params #\&)))
           (let loop ((pairs pairs))
             (or (null? pairs)
                 (let* ((pair (car pairs))
                        (kv (string-split pair #\=)))
                   (if (string=? (car kv) param)
                       (cadr kv)
                       (loop (cdr pairs))))))))))


(define (yt-dlp-download url path)
  (run-command (command-append
                "yt-dlp"
                "-x"
                "--extract-audio"
                "-o"
                path
                url)))


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

(define main (
  (setup)
  (run-fibers
   (lambda ()
     (run-server handler)))))
