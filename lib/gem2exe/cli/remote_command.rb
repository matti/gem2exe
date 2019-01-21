# frozen_string_literal: true

module Gem2exe
  module Cli
    class RemoteCommand < Clamp::Command
      parameter "GEM", "gem"
      parameter "VERSION", "version"
      parameter "ENTRYPOINT", "entrypoint"

      option "--cache-dir", "CACHE_DIR", "build cache dir"
      option "--out", "OUT", "executable, defaults to entrypoint"

      def execute
        Gem2exe.ensure_setup
        out_with_path = out || entrypoint

        builder = Builder.new gem: gem, version: version, entrypoint: entrypoint, out: out_with_path, cache_dir: cache_dir
        builder.build
      end
    end
  end
end
