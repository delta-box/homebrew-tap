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
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.2/deltabox-0.4.2-aarch64-apple-darwin.tar.gz"
      sha256 "f60635271b8d74e8a4cf0ab1129e6224c88d1ef4cdc4e44a5c54025456165607"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.2/deltabox-0.4.2-x86_64-apple-darwin.tar.gz"
      sha256 "14447be4cc94fdd98ad37c6fca7307f3507ad6020749c0832264c7c8e9708fc2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.2/deltabox-0.4.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "35728ed0e2f8191d0210028cbfc2fac95a42e80a1f830b8371ccf302afad7b71"
    end
    on_intel do
      url "https://github.com/delta-box/deltabox-lite/releases/download/v0.4.2/deltabox-0.4.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b95f77fc4271fbbaf15d43aad7d9a503513ac1e69ba915c9ffb062bff6c86098"
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
