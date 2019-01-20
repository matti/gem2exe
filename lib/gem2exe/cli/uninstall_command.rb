# frozen_string_literal: true

module Gem2exe
  module Cli
    class UninstallCommand < Clamp::Command
      def execute
        Gem2exe.uninstall

        puts "done"
      end
    end
  end
end
