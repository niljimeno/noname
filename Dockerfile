FROM alpine:3.18
RUN apk add guile guile-dev yt-dlp git make autoconf automake
RUN apk add libtool libgcrypt autoconf-archive pkgconf build-base
RUN apk add texinfo gmp-dev
# gettext
RUN git clone https://codeberg.org/guile/fibers /tmp/fibers
RUN mkdir -p /usr/local/share/guile/site/3.0/

RUN cd /tmp/fibers && ./autogen.sh && ./configure && make && make install

WORKDIR /var/www/music-player

COPY ./ /var/www/music-player

EXPOSE 8080

CMD ["make", "run"]
