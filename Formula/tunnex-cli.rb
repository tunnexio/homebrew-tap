class TunnexCli < Formula
  desc "Command-line client for Tunnex Zero Trust networking"
  homepage "https://tunnex.io"
  url "https://github.com/tunnexio/tunnex/archive/ac9b58b6ca02585cd00a7015871e7ab76f6a9853.tar.gz"
  version "0.1.42"
  sha256 "8484b280c7af08d6ae4aba3b00b9908e9c0fab0b2ab2653795c30af2436e77a5"
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
