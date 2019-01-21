require "tmpdir"

module Gem2exe
  class Unpacker
    def initialize(gem:,version:)
      @gem = gem
      @version = version
      @tmpdir = Dir.mktmpdir
      @path = File.join(
        @tmpdir,
        "#{@gem}-#{@version}"
      )
    end
    attr_reader :path

    def unpack
      cmd = ["gem", "unpack", @gem, "-v", @version]

      r = Runner.run! cmd, chdir: @tmpdir, output: true
      unless r.stderr.start_with? "Unpacked gem:"
        exit 1
      end

      self
    end
  end
end
