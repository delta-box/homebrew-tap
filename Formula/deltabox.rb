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
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.3.0/deltabox-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "9d45f9a45e334070e016f77e40a20949c946afc2a7cf68a60e777601a17b798b"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.3.0/deltabox-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "62fd425f4bad39d3fb1a7e18619ee32084750dd499f8cf62246df14e061168a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.3.0/deltabox-0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fef4347d2a59f08cba643bbbbcbc0586d3a470bbfdb57a45a33c8b6c77f1b1ab"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.3.0/deltabox-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "16645377c445a9ecf393978321c8dcf4b97051a3c549f734871abda0a79a914b"
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
