# typed: false
# frozen_string_literal: true

class Greet < Formula
  desc "Hello World"
  homepage "https://github.com/koriym/MyVendor.HelloCli"
  head "https://github.com/koriym/MyVendor.HelloCli.git", branch: "1.x"
  license "MIT"

  depends_on "php"
  depends_on "composer"

  def install
    libexec.install Dir["*"]

    cd libexec do
      system "composer", "install", "--prefer-dist"

      # Generate CLI commands and get the generated command name
      output = Utils.safe_popen_read("#{libexec}/vendor/bear/cli/bin/bear-cli-gen", "MyVendor\HelloCli")
      generated_command = output.match(/CLI commands have been generated.*:\n\s+(\w+)/)[1]

      if File.exist?("bin/#{generated_command}")
        bin.mkpath
        mv "bin/#{generated_command}", bin/generated_command
        chmod 0755, bin/generated_command
      end
    end
  end

  test do
    Dir["#{bin}/*"].each do |cmd|
      assert_match "Usage:", shell_output("#{cmd} --help")
    end
  end
end
