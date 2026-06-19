class Awsctx < Formula
  desc "Switch AWS SSO profiles in the current shell"
  homepage "https://github.com/lemtoc/awsctx"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.1/awsctx-aarch64-apple-darwin.tar.xz"
      sha256 "8867c04636e49eb70ede00d9fae01f48a2295fd6cf85fd800627d9705177ce8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.1/awsctx-x86_64-apple-darwin.tar.xz"
      sha256 "fb72196fc785c28dd2fef525bcaf9c0c66ff60b967fbb2c9db07efdffa4f8ff9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.1/awsctx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7540ab34d3eb1e5a162af8567180ff5551299ac89ae618690669062b22462102"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.1/awsctx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3062a4f9e1fa898cdd9e5b58d7f0f5d3bda977c15f8d801aa81da281be270add"
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
