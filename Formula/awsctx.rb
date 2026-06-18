class Awsctx < Formula
  desc "Switch AWS SSO profiles in the current shell"
  homepage "https://github.com/lemtoc/awsctx"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.1.0/awsctx-aarch64-apple-darwin.tar.xz"
      sha256 "e501ca06904407d59b48cda638386b4facc41cb67bfa90e5d60b72015fbff1bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.1.0/awsctx-x86_64-apple-darwin.tar.xz"
      sha256 "5e2988cf2163bd658d2a9a863eb27397aee5b07773a2f0cd1788adc51d16a136"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.1.0/awsctx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "da8daa4d52591f3783f983744af296cf8926477f713603527ff6741aed7e2c81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.1.0/awsctx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5bd987e36402c96d61e3c89888769016b9b47233e1acc3363526a2c5c3509d2f"
    end
  end
  license "MIT"

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
    bin.install "awsctx" if OS.mac? && Hardware::CPU.arm?
    bin.install "awsctx" if OS.mac? && Hardware::CPU.intel?
    bin.install "awsctx" if OS.linux? && Hardware::CPU.arm?
    bin.install "awsctx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
