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
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.0/deltabox-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "9823104ca1910e43c5f1008386628d9dc5795aeab32d9d20780f670b847b5624"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.0/deltabox-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "69edcf90f2a3aa3fc46c5034bf2cec52f5756e7fc9e0efae6a8700740975af42"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.0/deltabox-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6e62fb89b9bdb02368395396e608494cafb9feddc5cd47ebda38286c493af839"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.0/deltabox-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fb36c9d548571c045ee525778ef843b1d543e0514b8fb31bbd5e58b66a042b69"
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
