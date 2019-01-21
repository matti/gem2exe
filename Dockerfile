FROM ruby:2.6.0 as builder

WORKDIR /build
COPY . .

RUN bundle install --without development
RUN rake install
RUN gem2exe setup
RUN gem2exe local gem2exe

# -----------
FROM ubuntu:18.04

COPY --from=builder /build/gem2exe /usr/local/bin
RUN /usr/local/bin/gem2exe setup
ENTRYPOINT [ "/usr/local/bin/gem2exe" ]
