require "open3"

module Gem2exe
  class RunnerError < StandardError
  end
  class RunnerBuffer
    def initialize
      @buffer = []
    end

    def <<(c)
      @buffer << c
    end

    def to_s
      @buffer.join ""
    end

    def method_missing(m, *args, &block)
      to_s.send m, *args, block
    end
  end

  class Runner
    def initialize(cmd, env:nil, shell:false, sudo:false, chdir:nil, output:false,prepend:{})
      cmd.insert(0, "sudo") if sudo
      @cmd = if shell
        ["sh","-c"] + [cmd.join(" ")]
      else
        cmd
      end

      @env = (env || {})
      @opts = {}
      @opts[:chdir] = chdir if chdir
      @output = output
      @prepend = {}
      if prepend[:stdboth]
        @prepend[:stderr] = prepend[:stdboth]
        @prepend[:stdout] = prepend[:stdboth]
      else
        @prepend = prepend
      end

      @status, @stdout, @stderr, @stdboth = nil, RunnerBuffer.new, RunnerBuffer.new, RunnerBuffer.new
    end
    attr_reader :status, :stdout, :stderr, :stdboth

    def self.run!(cmd_string_or_array, opts={})
      cmd = if cmd_string_or_array.is_a? Array
        cmd_string_or_array
      else
        cmd_string_or_array.split(" ")
      end

      runner = self.new cmd, opts
      runner.run

      if runner.status.exitstatus != 0
        exit 1
      end

      runner
    end

    def run
      executable, *args = @cmd
      stdin, stdout, stderr, wait_thr = Open3.popen3(@env, executable, *args, @opts)

      stderr_thr = Thread.new do
        stderr.each do |line|
          @stdboth << line
          @stderr << line
          if @prepend[:stderr]
            $stdout.print @prepend[:stderr]+line
          else
            $stdout.print line
          end
        end
      end

      stdout_thr = Thread.new do
        stdout.each do |line|
          @stdboth << line
          @stderr << line

          if @prepend[:stdout]
            $stdout.print @prepend[:stdout]+line
          else
            $stdout.print line
          end
        end
      end

      wait_thr.join
      stdout_thr.join
      stderr_thr.join

      @status = wait_thr.value
    end
  end
end
