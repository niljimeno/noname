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
(load "json.scm")

(load "repository/db.scm")

(load "routes/song.scm")
(load "routes/search.scm")
(load "routes/not-found.scm")


(define (url-sections url)
  (drop (string-split url #\/) 1))

(define (handler request body)
  (let ((url (uri-path (request-uri request))))
    (router (main-section (first (url-sections url))) body)))

(define (router section body)
  (cond ((equal? main-section "song")
         (route-download-song body))
        ((equal? main-section "search")
         (route-search-songs body))
        (else (route-not-found))))


(define (setup)
  (run-command (command-append "mkdir" "-p" "target")))

(define main
  ((setup)
   (run-server handler #:host "0.0.0.0" #:port 8080)))
