# frozen_string_literal: true

module Gem2exe
  module Cli
    class RootCommand < Clamp::Command
      banner "🔆 gem2exe #{Gem2exe::VERSION}"

      option ['-v', '--version'], :flag, "Show version information" do
        puts Gem2exe::VERSION
        exit 0
      end

      subcommand ["setup"], "setup", SetupCommand
      subcommand ["uninstall"], "uninstall", UninstallCommand

      subcommand ["local"], "local", LocalCommand
      subcommand ["remote"], "remote", RemoteCommand

      subcommand ["version"], "Show version information", VersionCommand

      def self.run
        super
      rescue StandardError => exc
        warn exc.message
        warn exc.backtrace.join("\n")
      end
    end
  end
end
