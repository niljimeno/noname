Not meant for public usage.

## Usage
- Run using `make run`
- Go to `:8080/song?url=<video-id>` to download a song, the id being the code after `v=`
- Go to `:8080/search?q=<search-query>` to get search results. They barely work.

## Dependencies
- Guile 3.0
- Guile-fibers
- yt-dlp

### Installing guile-fibers
Install the [guile-fibers library](https://codeberg.org/guile/fibers)
and place it in one of guile's load paths
(`guile -c '(display %load-path)'`).
The library includes `fibers.scm` and the contents inside `fibers/`.
