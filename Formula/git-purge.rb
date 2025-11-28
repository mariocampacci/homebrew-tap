class GitPurge < Formula
  desc "Git extension to purge stale local branches deleted from remote."
  homepage "https://github.com/mariocampacci/git-purge"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.0/git-purge-aarch64-apple-darwin.tar.xz"
      sha256 "0b28340c1bde11f9021d899fd1198b4ae4cb9e24bd69320b0589702050535618"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.0/git-purge-x86_64-apple-darwin.tar.xz"
      sha256 "993cc92f2b794a7b90bcbbbd6a9905c9d005cf73013ba906ab5b8b306712060d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.0/git-purge-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cae6e6bf8572133d02075ca931bd003904f0b339c2a8e0ccdaec2b75a0ccc7b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.0/git-purge-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "402063621d1d60f1fbcfcee70336c1a1a3f99a1d0feb04c58dfc954575fe13ab"
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
