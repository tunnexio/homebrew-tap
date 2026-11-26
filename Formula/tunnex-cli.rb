class TunnexCli < Formula
  desc "Command-line client for Tunnex Zero Trust networking"
  homepage "https://tunnex.io"
  url "https://github.com/tunnexio/tunnex/archive/bac2be3a497866417b372c4161878fd212b0ed5e.tar.gz"
  version "0.1.50"
  sha256 "b86fef2cc44c7896609146bd8c6455ee97b6d74c21b0a49409818486565dbfbc"
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
