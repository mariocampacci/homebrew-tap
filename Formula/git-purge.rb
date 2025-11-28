class GitPurge < Formula
  desc "Git extension to purge stale local branches deleted from remote."
  homepage "https://github.com/mariocampacci/git-purge"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.0/git-purge-aarch64-apple-darwin.tar.xz"
      sha256 "f9f437fc3fc9f75acbb422a76650c84311bb38db9322d5042d8f734f576d2da8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.0/git-purge-x86_64-apple-darwin.tar.xz"
      sha256 "70f415f7b1e80d0fa2ae7af82c577ead81ba96baf77e4f2b00a4421ca1c56969"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.0/git-purge-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a675e47df416309d88a5c540a8ffc6d7600adf2308e26e0a9a2ffc5d4c22f8ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.0/git-purge-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c324ad8a842daf1577ad67784f099b421e72ce28319c7445c78c1e2468f1db3d"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "git-purge" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-purge" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-purge" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-purge" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
