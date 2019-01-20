require "fileutils"

module Gem2exe
  def self.cores
    Integer(`sysctl -n hw.ncpu`)
  end

  def self.uninstall
    FileUtils.rm_rf install_path
  end

  def self.ensure_rubyc
    return if File.exists? self.rubyc_path
    FileUtils.mkdir_p File.dirname(self.rubyc_path)

    rubyc_url = if self.platform == "darwin"
#      "https://github.com/kontena/ruby-packer/releases/download/2.6.0-0.6.0/rubyc-2.6.0-0.6.0-osx-amd64.gz"
      "https://dl.bintray.com/kontena/ruby-packer/0.5.0-dev/rubyc-0.5.0-extra2-darwin-amd64.gz"
    else
      "https://github.com/kontena/ruby-packer/releases/download/2.6.0-0.6.0/rubyc-2.6.0-0.6.0-linux-amd64.gz"
    end

    $stderr.puts "downloading rubyc from #{rubyc_url}"
    `sh -c "curl -sL #{rubyc_url} | gunzip > #{self.rubyc_path}"`
    `chmod +x #{self.rubyc_path}`
    $stderr.puts "installed in #{self.rubyc_path}"
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
