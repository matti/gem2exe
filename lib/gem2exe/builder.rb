require "tmpdir"

module Gem2exe
  class Builder
    def initialize(path:,entrypoint:,out:,cores:nil,cache_dir:nil)
      @path = path
      @entrypoint = entrypoint
      @out = out
      @cores = (cores || self.cores+1)
      @tmpdir = (cache_dir || Dir.mktmpdir)
    end

    def build
      cmd = [Gem2exe.rubyc_path]
      if Gem2exe.platform == "darwin"
        cmd += ["--openssl-dir", "/usr/local/etc/openssl"]
      else
        cmd += ["--openssl-dir=", "/etc/ssl"]
      end
      cmd += ["--root", @path]
      cmd += ["-o", @out]
      cmd += ["-d", @tmpdir]
      cmd += ["--make-args", "-j#{@cores}"]
      cmd += [@entrypoint]

      Runner.run! cmd, output: true
    end


    protected

    def cores
      if Gem2exe.platform == "darwin"
        Integer(`sysctl -n hw.ncpu`)
      else
        Integer(`nproc`)
      end
    end
  end
end
