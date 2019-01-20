FROM ruby:2.6.0 as builder

RUN apt-get update && apt-get install -y squashfs-tools build-essential bison curl openssl

RUN curl -sL https://github.com/kontena/ruby-packer/releases/download/0.5.0%2Bextra7/rubyc-0.5.0+extra7-linux-amd64.gz | gunzip > /usr/local/bin/rubyc
RUN chmod +x /usr/local/bin/rubyc

RUN update-ca-certificates

WORKDIR /app
COPY . .

RUN rubyc --openssl-dir=/etc/ssl -o gem2exe -d /tmp/build --make-args="-j$((`nproc`+1))" gem2exe

# -----------
FROM ubuntu:18.04
COPY --from=builder /app/gem2exe /usr/local/bin
RUN /usr/local/bin/gem2exe setup
ENTRYPOINT [ "/usr/local/bin/gem2exe" ]
