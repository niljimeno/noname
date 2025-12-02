FROM alpine:3.18
RUN apk add --no-cache guile yt-dlp git make
RUN git clone https://codeberg.org/guile/fibers /tmp/fibers
RUN cp /tmp/fibers/fibers.scm /usr/share/guile/3.0/
RUN cp -r /tmp/fibers/fibers /usr/share/guile/3.0/fibers
RUN mkdir -p /var/www/music-player

WORKDIR /var/www/music-player

COPY ./ /var/www/music-player

EXPOSE 8080

CMD ["make", "run"]
