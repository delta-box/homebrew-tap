# Homebrew formula for the deltabox CLI. Installs the prebuilt binary from the
# GitHub release for the current platform; nothing is compiled on the user's
# machine, so `brew install` takes seconds and needs no Rust toolchain.
#
# This file is the source of truth. scripts/update-homebrew-formula.mjs
# rewrites the version, URLs, and checksums on every release, and the
# prebuilds workflow copies the result to Formula/deltabox.rb in the tap
# repository (delta-box/homebrew-tap), which is what `brew tap delta-box/tap`
# reads. Every URL and sha256 below is literal on purpose: Homebrew parses the
# version out of the URL (so there is no `version` line) and audits reject
# interpolation.
class Deltabox < Formula
  desc "Native sandbox runtime with diff, commit, and abort for AI coding agents"
  homepage "https://github.com/delta-box/deltabox-lite"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.1/deltabox-0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "bda59cd0dea15ea6b22b8352f5ce0622c402bc13ab6a66c4ff987811f3d3ba74"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.1/deltabox-0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "2243bb3a0b438628d1e9947792aaecef98798f9344883042203f06ad011e9417"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.1/deltabox-0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3de6db1d5c7db75f38c5353a2a9dde3c9c7d6f54e8194ba4987e009902f0250e"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.1/deltabox-0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4bfbb5bee172309e80d82fc2b90b0590a13d9a071f90ce8987d8f967b59c5c83"
    end
  end

  def install
    bin.install "deltabox"
  end

  def caveats
    return unless OS.linux?

    <<~EOS
      CB-CoW filesystem modes need /dev/fuse and fusermount3 (or fusermount)
      on the host. Without them, deltabox falls back to copy-private unless
      a mode is required.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deltabox --version")
  end
end
