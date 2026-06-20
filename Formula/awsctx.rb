class Awsctx < Formula
  desc "Switch AWS SSO profiles in the current shell"
  homepage "https://github.com/lemtoc/awsctx"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.2/awsctx-aarch64-apple-darwin.tar.xz"
      sha256 "4182d2b398ea0307200e5f4cf16c4e7144f4e76fdc3433a0b52cd5da37c93b82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.2/awsctx-x86_64-apple-darwin.tar.xz"
      sha256 "98117003aed7cc6bf0bee2b171c47956aec9bc9a9cd0ad8f12de0e56942575ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.2/awsctx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "28f7e902ddd979fcd34b83ca2428b429e99609a668a314717dc9e8489e003f01"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc/awsctx/releases/download/v0.2.2/awsctx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2098636bec3bd54a4854bbb650b314acfffdcf21b3a305746503677a4f51342c"
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
