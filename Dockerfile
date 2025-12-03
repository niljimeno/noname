FROM alpine:3.18
RUN apk add guile guile-dev git make autoconf automake
RUN apk add libtool libgcrypt autoconf-archive pkgconf build-base
RUN apk add texinfo gmp-dev

RUN apk add python3
RUN git clone https://github.com/yt-dlp/yt-dlp /var/www/yt-dlp
RUN echo "#!/usr/bin/env sh" > /usr/bin/yt-dlp
RUN echo 'exec "${PYTHON:-python3}" -Werror -Xdev "/var/www/yt-dlp/yt_dlp/__main__.py" "$@"' >> /usr/bin/yt-dlp
RUN chmod +x /usr/bin/yt-dlp

# gettext
RUN git clone https://codeberg.org/guile/fibers /tmp/fibers
RUN mkdir -p /usr/local/share/guile/site/3.0/

RUN cd /tmp/fibers && ./autogen.sh && ./configure && make && make install

WORKDIR /var/www/music-player

COPY ./ /var/www/music-player

EXPOSE 8080

CMD ["make", "run"]
