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
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.4/deltabox-0.1.4-aarch64-apple-darwin.tar.gz"
      sha256 "cd7278da67d4ee881f46f24dab1d8efab2c002aaa6f5177c3c67d21f259c8219"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.4/deltabox-0.1.4-x86_64-apple-darwin.tar.gz"
      sha256 "5d7b3db296c6a1ae1d4a23281fdba29dc67b56ac1221f0a98f311493be006fac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.4/deltabox-0.1.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2c746ede8ca9c9e334d4f1d9ef72bf8f66ba2e4c9a3fd42fb8e5c6a92ec1f2b4"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.4/deltabox-0.1.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fe1b6e8300f796795ad9bf230c8b2da4d6457721349e30d528449464eecb5187"
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
