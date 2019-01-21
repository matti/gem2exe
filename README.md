# gem2exe

Uses https://github.com/kontena/ruby-packer/releases

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

        TODO
