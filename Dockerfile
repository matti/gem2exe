FROM ruby:2.6.0 as builder

WORKDIR /build
COPY . .

RUN bundle install
RUN rake
RUN rake install
RUN gem2exe setup
RUN gem2exe local gem2exe

# -----------
FROM ubuntu:18.04
RUN apt-get update && apt-get install -y git-core
COPY --from=builder /build/gem2exe /usr/local/bin
RUN /usr/local/bin/gem2exe setup
ENTRYPOINT [ "/usr/local/bin/gem2exe" ]
