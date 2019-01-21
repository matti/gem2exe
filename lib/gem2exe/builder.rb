require "tmpdir"
require "fileutils"
module Gem2exe
  class Builder
    def initialize(path:nil,gem:nil,version:nil,entrypoint:,out:,cores:nil,cache_dir:nil)
      @gem = gem
      @version = version

      @path = path

      @entrypoint = entrypoint
      @out = out
      @tmpdir = (cache_dir || Dir.mktmpdir)

      @cores = (cores || self.cores+1)
    end

    def build
      FileUtils.mkdir_p File.dirname(@out)

      cmd = [Gem2exe.rubyc_path]
      if Gem2exe.platform == "darwin"
        cmd += ["--openssl-dir", "/usr/local/etc/openssl"]
      else
        cmd += ["--openssl-dir", "/etc/ssl"]
      end

      if @path
        cmd += ["--root", @path]
      elsif @gem
        cmd += ["--gem", @gem]
        cmd += ["--gem-version", @version]
      else
        raise "path or gem must be given"
      end

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
