class TunnexCli < Formula
  desc "Command-line client for Tunnex Zero Trust networking"
  homepage "https://tunnex.io"
  url "https://github.com/tunnexio/tunnex/archive/38f07a0551dac6d0cb14560e64ed2525ac8d5817.tar.gz"
  version "0.1.40"
  sha256 "e5a74091ad2bc25a00aa2baf5c3f568cbd4f9a38e9874ee8593b9372bd94727c"
  license "Apache-2.0"
  revision 1

  depends_on "go" => :build
  depends_on "wireguard-tools"

  def install
    cd "apps/cli" do
      system "go", "build", "-mod=readonly", "-trimpath", "-buildvcs=false",
             "-ldflags=-s -w -X main.version=v#{version}",
             "-o", bin/"tunnex", "./cmd/tunnex"
    end
  end

  def caveats
    <<~EOS
      WireGuard tools are installed. Configure a device before tunnex up/down.
      Login: tunnex login --server https://YOUR_CONTROL_PLANE
      CLI installation does not enroll a device or start a tunnel.
    EOS
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/tunnex version").strip
    assert_match "tunnex login", shell_output("#{bin}/tunnex help 2>&1")
  end
end
