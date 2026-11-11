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
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.1/deltabox-0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "ef37c2483d8fbf0a8ca101e78e4cd0cca28ed704f0e54bcbe1eae7886a0b2fc1"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.1/deltabox-0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "f6d61b5790089bed2c560809ac1566c0416c0a3c6adfa5d4b56fdd30f63c6e6c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.1/deltabox-0.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f428b92c8a4d90ae3fbcbbdb81d3c51765e6434f1301885152f4ab9d7bd03be1"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.1/deltabox-0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f6c478f6d8526a18a146461ad4124aeed8d2d28304e532897fc2997c7c9f83a5"
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
