# frozen_string_literal: true

require "tmpdir"

module Gem2exe
  module Cli
    class BuildCommand < Clamp::Command
      parameter "NAME", "name"
      option "--cache-dir", "CACHE_DIR", "build cache dir"

      def execute
        cores = Gem2exe.cores + 1
        tmpdir = if cache_dir
          cache_dir
        else
          Dir.mktmpdir
        end

        if Gem2exe.platform == "darwin"
          `"#{Gem2exe.rubyc_path}" --openssl-dir=/usr/local/etc/openssl -o "#{name}" -d "#{tmpdir}" --make-args="-j#{cores} --silent" #{name}`
        else
          `"#{Gem2exe.rubyc_path}" --openssl-dir=/etc/ssl rubyc -o "#{name}" -d "#{tmpdir}"  --make-args="-j#{cores}" #{name}`
        end
      end
    end
  end
end
