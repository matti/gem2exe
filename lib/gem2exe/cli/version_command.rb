# frozen_string_literal: true

module Gem2exe
  module Cli
    class VersionCommand < Clamp::Command
      def execute
        puts Gem2exe::VERSION
      end
    end
  end
end
