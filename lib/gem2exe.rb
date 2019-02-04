require "fileutils"

module Gem2exe
  def self.uninstall
    FileUtils.rm_rf install_path
  end

  def self.download_rubyc
    return if File.exist? rubyc_path
    FileUtils.mkdir_p File.dirname(self.rubyc_path)

    rubyc_url = if self.platform == "darwin"
      "https://github.com/kontena/ruby-packer/releases/download/2.6.0-0.6.0/rubyc-2.6.0-0.6.0-osx-amd64.gz"
    else
      "https://github.com/kontena/ruby-packer/releases/download/0.5.0%2Bextra7/rubyc-0.5.0+extra7-linux-amd64.gz"
    end

    $stderr.puts "downloading rubyc from #{rubyc_url}"

    Runner.run! "curl -sL #{rubyc_url} | gunzip > #{self.rubyc_path}", shell: true
    Runner.run! "chmod +x #{self.rubyc_path}"

    $stderr.puts "installed in #{self.rubyc_path}"
  end

  def self.ensure_setup
    unless File.exists? self.rubyc_path
      $stderr.puts "rubyc not found - run: gem2exe setup"
      exit 1
    end
  end

  def self.rubyc_path
    install_path_parts = [self.install_path]
    install_path_parts << self.platform
    install_path_parts << "rubyc-for-gem2exe-#{Gem2exe::VERSION}"

    File.join install_path_parts
  end

  def self.platform
    if /darwin/ =~ RUBY_PLATFORM
      "darwin"
    else
      "linux"
    end
  end

  def self.install_path
    File.join Dir.home, ".gem2exe"
  end
end

require_relative "gem2exe/version"
require_relative "gem2exe/builder"
require_relative "gem2exe/runner"
