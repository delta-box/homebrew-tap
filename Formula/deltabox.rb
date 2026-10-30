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
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.5/deltabox-0.1.5-aarch64-apple-darwin.tar.gz"
      sha256 "46590d7cdaa77de279cf107f12f58a8f8dc9b032b1e47b325f00ee7e67163e1a"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.5/deltabox-0.1.5-x86_64-apple-darwin.tar.gz"
      sha256 "9590a1b1949336d0db4e5973fd49de12a8fcdea120fa406c586fee2cc779621d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.5/deltabox-0.1.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9eca4621c3ae00a8da18806da85513000193c29c8bc0174c6a8d8d9c080dbbf1"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.5/deltabox-0.1.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b5b52c975432c953b906b956d3f3932133730fb88402002dbe01363296e6eb20"
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
