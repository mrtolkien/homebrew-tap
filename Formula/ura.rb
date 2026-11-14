class Ura < Formula
  desc "The ura command-line tool."
  homepage "https://github.com/mrtolkien/uraeda"
  version "2.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v2.1.0/uraeda-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ac1a6dfa4e91cd515252c7bfcf0f61f6a8164779fbb90062473a924aea85964e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v2.1.0/uraeda-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ddf748a925d2b0e40155d062621a1014a2eec5c9b8009bb4d862766e9239c469"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrtolkien/uraeda/releases/download/v2.1.0/uraeda-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c5f6618898f02527452c9a5888971feba663d77172f3a0f84f49a3185eb6abf0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrtolkien/uraeda/releases/download/v2.1.0/uraeda-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4919c6a06e58e807789f5556376477ab54bf2de2b8e4214199bb4f783583a752"
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
