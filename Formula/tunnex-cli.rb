class TunnexCli < Formula
  desc "Command-line client for Tunnex Zero Trust networking"
  homepage "https://tunnex.io"
  url "https://github.com/tunnexio/tunnex/archive/853f37e7ee6ab33074cfba83dc7eef370cf3b3eb.tar.gz"
  version "0.1.39"
  sha256 "a2918d931e1230fab9e3d0e20749db39f9e6eee2b87439503ac3fc887af0612f"
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
