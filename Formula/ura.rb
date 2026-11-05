class Ura < Formula
  desc "The ura command-line tool."
  homepage "https://github.com/mrtolkien/uraeda"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v1.1.0/uraeda-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9aeaa3bbc76d7d37b5235aaf358e23657a0acdfea4d29f5c8fa01f314b01e36a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v1.1.0/uraeda-cli-x86_64-apple-darwin.tar.xz"
      sha256 "699324d43685508d4820230503ce22d72876cf712a07da04aadbf179a3db0227"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v1.1.0/uraeda-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bf1a3d44b62119bff95c5e64783165b0a18a477abfac1066507f3975b4ad3da8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v1.1.0/uraeda-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "156a10452febeda129fcdcb8d4e9e420e1c2c2ce6e1e40aa5cbd4ec03e04708e"
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
