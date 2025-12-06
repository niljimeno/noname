(use-modules (ice-9 popen)
             (srfi srfi-26)
             (ice-9 rdelim))


(define (with-input-from-pipe command thunk)
  (let ((old (current-input-port))
        (pipe (open-input-pipe command)))
    (dynamic-wind
      (cute set-current-input-port pipe)
      thunk
      (lambda ()
        (set-current-input-port old)
        (close-pipe pipe)))))

(define (run-command command)
  (with-input-from-pipe
    command
    read-string))


(define (command-append . commands)
  (fold-right
   (lambda (str prev)
     (string-append str " " prev))
   ""
   commands))


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
