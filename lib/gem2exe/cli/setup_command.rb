# frozen_string_literal: true

module Gem2exe
  module Cli
    class SetupCommand < Clamp::Command
      def execute
        Gem2exe.ensure_rubyc

        puts "ready"
      end
    end
  end
end
