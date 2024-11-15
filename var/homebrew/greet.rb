# typed: false
# frozen_string_literal: true

class Greet < Formula
  desc "Command line interface for MyVendor\HelloCli application"
  homepage "https://github.com/koriym/Greet"
  head "https://github.com/koriym/Greet.git", branch: "1.x"
  license "MIT"

  depends_on "php@8.3"
  depends_on "composer"

  def install
    libexec.install Dir["*"]

    cd libexec do
      system "composer", "install", "--prefer-dist", "--no-dev", "--no-interaction" or raise "Composer install failed"
      system "mkdir", "-p", "bin" unless File.directory?("bin")

      # Generate CLI commands and get the generated command name
      output = Utils.safe_popen_read("#{libexec}/vendor/bear/cli/bin/bear-cli-gen", "MyVendor\\HelloCli")
      # Extract multiple commands from the output
      generated_commands = output.scan(/CLI commands have been generated.*?:
\s+(.+)$/m)[0][0].split(/\s+/)
      ohai "Generated commands:", generated_commands.join(", ")

      generated_commands.each do |command|
        if File.exist?("bin/cli/#{command}")
          bin.mkpath
          mv "bin/cli/#{command}", bin/command
          chmod 0755, bin/command
        end
      end
    end
  end

  test do
    bin_files = Dir["#{bin}/*"]
    if bin_files.empty?
      raise "No files found in #{bin}. Installation may have failed."
    end

    bin_files.each do |cmd|
      assert system("test", "-x", cmd), "#{cmd} is not executable"
      assert_match "Usage:", shell_output("#{cmd} --help"), "Help command failed for #{cmd}"
    end
  end
end