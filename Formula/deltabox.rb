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
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.2/deltabox-0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "3d69c545e7484be722152f3c2285103476d3922f805ebefa0090c5932197d195"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.2/deltabox-0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "9dab62730cb5dfb08dc3f84e827033ec10f8e7ffe07491389f138794f1119155"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.2/deltabox-0.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b35949b1bef7bfb2bd480652ca2cde8747d27138dfe1687784750b5248509987"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.1.2/deltabox-0.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7dadc9f97f8eef1d81cf4263ed9216b0b1884da1d81492b94963b3436c7a0f8b"
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
