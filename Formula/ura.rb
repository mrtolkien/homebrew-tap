class Ura < Formula
  desc "The ura command-line tool."
  homepage "https://github.com/mrtolkien/uraeda"
  version "3.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.1.1/uraeda-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a90e38a092f8feafc22a6a89b5a8e43bee8d9d8d5542c4bc1be07ca80dfe00e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.1.1/uraeda-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ab6dec0b960db5b14a7c47db6a907ff8a37b24328bdd9ef28eeb76bfa536efd5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.1.1/uraeda-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1d2cb0d67ff0ff69096b4507e6a615ab1e621c05297c585a21ef74e83505dffc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v3.1.1/uraeda-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "943734b1189f9b0b2a65f87c82061973f27eb23d132b437047ea4045e5aa4b1f"
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
