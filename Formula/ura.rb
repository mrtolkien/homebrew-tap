class Ura < Formula
  desc "The ura command-line tool."
  homepage "https://github.com/mrtolkien/uraeda"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v0.7.0/uraeda-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4947c5883a2195eebd6e17fbf509d1cad1ce3847d7373b5f247b8df87be00433"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v0.7.0/uraeda-cli-x86_64-apple-darwin.tar.xz"
      sha256 "416a69492fda7d21582833f44e2da88f2b8dd0f6d4c6deeb410b7fda0cb30aa1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v0.7.0/uraeda-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "82ff50abb490b9b3c105efefac6b3e6dd0bda3fca0a6af9ed2016144533000ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v0.7.0/uraeda-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a333d67e2fc0b61f427c1527bf54b08bbccfa0e7ca29c696d2673c212ed59f6e"
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

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
