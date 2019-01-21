# frozen_string_literal: true

module Gem2exe
  module Cli
    class LocalCommand < Clamp::Command
      parameter "ENTRYPOINT", "entrypoint"
      option "--cache-dir", "CACHE_DIR", "build cache dir"
      option "--path", "PATH", "path to gem, defaults to working directory"
      option "--out", "OUT", "executable, defaults to entrypoint"

      def execute
        Gem2exe.ensure_setup

        out ||= entrypoint

        path_expanded = if path
          File.expand_path(path)
        else
          Dir.pwd
        end

        builder = Builder.new path: path_expanded, entrypoint: entrypoint, out: out, cache_dir: cache_dir
        builder.build
      end
    end
  end
end
