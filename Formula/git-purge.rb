class GitPurge < Formula
  desc "Git extension to purge stale local branches deleted from remote."
  homepage "https://github.com/mariocampacci/git-purge"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.1/git-purge-aarch64-apple-darwin.tar.xz"
      sha256 "78f8514f9124fee03822d3768a9e467f981b192a8d4363c865e49033162b33f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.1/git-purge-x86_64-apple-darwin.tar.xz"
      sha256 "5002c562a7db6590e2ca8ed3c4dc43b4a87e0db2608c0dd872be7c441c1cfc53"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.1/git-purge-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "890ad516b6cafb6ecdbb258823e36dd17fdee4c5737bc3babaf3afbd482f12b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mariocampacci/git-purge/releases/download/v0.1.1/git-purge-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "66f2d769926f3d40cdec42618997ee66e34dfbfc8ef5e6f14b413483fba445db"
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
