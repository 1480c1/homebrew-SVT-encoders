class SvtAv1 < Formula
  desc "Multicore AV1 Encoder from OpenVisualCloud"
  homepage "https://github.com/OpenVisualCloud/SVT-AV1"
  url "https://github.com/OpenVisualCloud/SVT-AV1/archive/v0.6.0.tar.gz"
  sha256 "4ff6f05a9528fe8a7b3d6708fe1115d15d26a5a9b0b676d8a250a0b2e8630579"
  head "https://github.com/OpenVisualCloud/SVT-AV1.git"

  bottle do
    root_url "https://dl.bintray.com/1480c1/bottles-svt-encoders"
    cellar :any_skip_relocation
    sha256 "efe5b822516cfe70171033073839baeaa17b555726c18dcf131747a74af9467c" => :mojave
    sha256 "55d2c8452aa3a253f0223ede771cdf56a96828fdc7613ab38ce1db192adc1abf" => :high_sierra
    sha256 "e68e8c00dc40449fdcb0b41882c00966e641b4da0b98acee83f6d8735f5631e6" => :sierra
    sha256 "178f841856986efc4a5a2fa6cf1f882214294e358a8de87c8c35f9619ba5aa7d" => :x86_64_linux
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
