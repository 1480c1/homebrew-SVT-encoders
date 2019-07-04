class SvtAv1 < Formula
  desc "Multicore AV1 Encoder from OpenVisualCloud"
  homepage "https://github.com/OpenVisualCloud/SVT-AV1"
  url "https://github.com/OpenVisualCloud/SVT-AV1/archive/v0.6.0.tar.gz"
  sha256 "4ff6f05a9528fe8a7b3d6708fe1115d15d26a5a9b0b676d8a250a0b2e8630579"
  version "0..0"
  head "https://github.com/OpenVisualCloud/SVT-AV1.git"

  bottle do
    root_url "https://dl.bintray.com/1480c1/bottles-svt-encoders"
    cellar :any
    sha256 "627ce71bfac21cf370bd769260f11c0f78686a404ab83f98e51dd36577a1ede0" => :mojave
    sha256 "a4fb6744dd9761cb8f30530f44f78c7768aaf0b5b906164e01c2b362a6119218" => :high_sierra
    sha256 "e68e8c00dc40449fdcb0b41882c00966e641b4da0b98acee83f6d8735f5631e6" => :sierra
    sha256 "191fb3568e8b1ef5c35342dad9d7498831d7be670d9b3496246411dcfec55464" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    mkdir "_build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_TESTING=OFF", "-DNATIVE=OFF"
      system "make", "install"
      prefix.install_metafiles
    end
  end

  def caveats
    "The SVT-AV1 encoder is still not fully stable yet."
  end

  test do
    system "#{bin}/SvtAv1EncApp", "-help"
    resource("bus_qcif_15fps.y4m").stage do
      system "#{bin}/SvtAv1EncApp", "-enc-mode", "8",
                                    "-i", "bus_qcif_15fps.y4m",
                                    "-b", "bus_qcif_15fps.ivf"
    end
  end
end
