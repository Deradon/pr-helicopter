FROM alpine:3.2
MAINTAINER Sebastian Katzer "sebastian.katzer@wimdu.com"

ENV REPO wimdu/wimdu
ENV SECRET 40digitsecret
ENV HOOK_URL http://heli.wimdu.pagekite.me
ENV BUILD_PACKAGES yaml
ENV RUBY_PACKAGES ruby

# Update and install all of the required packages.
# At the end, remove the cache
RUN apk update && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/* && \
    rm -rf /usr/share/ri

RUN mkdir /usr/app
WORKDIR /usr/app

COPY . /usr/app

CMD ["./service"]
