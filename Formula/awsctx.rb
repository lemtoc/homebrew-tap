class Awsctx < Formula
  desc "Switch AWS SSO profiles in the current shell"
  homepage "https://github.com/lemtoc/awsctx"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.3/awsctx-aarch64-apple-darwin.tar.xz"
      sha256 "8e400fe380a0f46815c24a428465f56e3599d8c251a27de3fd6a0cc922369def"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.3/awsctx-x86_64-apple-darwin.tar.xz"
      sha256 "6bf029cd28bf6f4e7e8b324c91efbf6277d25ec0e6661d7960ea17f283936fa5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.3/awsctx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0b77b4a5a178c0936548e8511387cd626ee6df8675776fc71aabbf640ae81da6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.3/awsctx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f4eefd5e4238a77ca7a7bca62149e53aad8169a0efe79fddb142e6ac2d3c26da"
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
