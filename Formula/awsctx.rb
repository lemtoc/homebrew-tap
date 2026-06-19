class Awsctx < Formula
  desc "Switch AWS SSO profiles in the current shell"
  homepage "https://github.com/lemtoc/awsctx"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.0/awsctx-aarch64-apple-darwin.tar.xz"
      sha256 "e18dcf9604c851ddbe86d107123d61d3421b09fe4ac29a09e6742f7088ce318b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.0/awsctx-x86_64-apple-darwin.tar.xz"
      sha256 "038a7de1f85567620bfd35b15cf98f0634c31d9d9559df8738b60d9041444680"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.0/awsctx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8fa4b9cf0a52cfc4ff7fea9a5ec5770b84bf6c2eb18b5a8f1be9ad4ac7b19d5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.0/awsctx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7ee17903d5243d9d403951eb86d0b5047cb7e3c81f9214ec3848281abcce2ac0"
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
