class Ura < Formula
  desc "The ura command-line tool."
  homepage "https://github.com/mrtolkien/uraeda"
  version "3.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.3.0/uraeda-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e448ca13c6f418898656070191fc051ab45d33bc8a580f507a82a53fc9cc19f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.3.0/uraeda-cli-x86_64-apple-darwin.tar.xz"
      sha256 "fc9695d14ee3f9789b7e0ae667435014915bbdbe36495103a135a61f641238c6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.3.0/uraeda-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8a4f7ddd48a4405a10b34c46796d390d9ec9377e124a653b12369a2501458611"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.3.0/uraeda-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "839dfa763e1a35d6de01b050a54292b2fc349dd2a17c7ec0b52f658281f0e8f7"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ura"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ura"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ura"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ura"
    end

    install_binary_aliases!
    generate_completions_from_executable(bin/"ura", shell_parameter_format: :clap, shells: [:fish, :zsh])

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
