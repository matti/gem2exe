# gem2exe

Uses https://github.com/kontena/ruby-packer/releases

## Install

See https://github.com/matti/gem2exe/releases

## local gems

Building a local gem:

        cd yourgem
        gem2exe local command-to-start-gem

Full options:

        gem2exe local --path /path/to/your/gem \
            --out /build/name \
            --cache-dir /tmp/cache \
            command-to-start-gem

## remote gems

        gem2exe remote gemname version command-to-start-gem

## linux and docker

Travis example:

```
jobs:
  include:
    - stage: binary
      os: linux
      services:
        - docker

      before_install:
        - docker pull mattipaksula/gem2exe
      script:
        - mkdir releases
        - docker run --name gem2exe -it --volume $(pwd):/gem mattipaksula/gem2exe local --path /gem --out /tmp/gbuild gbuild
        - docker cp gem2exe:/tmp/gbuild releases/gbuild-linux-amd64-${TRAVIS_TAG}
```
