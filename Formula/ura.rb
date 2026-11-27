class Ura < Formula
  desc "The ura command-line tool."
  homepage "https://github.com/mrtolkien/uraeda"
  version "3.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.4.0/uraeda-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b73c4030931d653e2dbc902a16bd1a4880eec6078573f6e39177b00c10cdedfe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.4.0/uraeda-cli-x86_64-apple-darwin.tar.xz"
      sha256 "62d66cc01209f5739d863ddd57f12ae5f5eae6ba49a427cc5ba50c3636a41ff9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.4.0/uraeda-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "38a5f1bb590bf7e4690892272714b7c5657a93ccee1a2d19cd7c3d7c42f52c15"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.4.0/uraeda-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d131f6a7bcd67112ec7a357141836e70af9ebb61eeb2dfe55bed9e631c22ab25"
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
