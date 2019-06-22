class SvtAv1 < Formula
  desc "Multicore AV1 Encoder from OpenVisualCloud"
  homepage "https://github.com/OpenVisualCloud/SVT-AV1"
  url "https://github.com/OpenVisualCloud/SVT-AV1/archive/v0.5.0.tar.gz"
  sha256 "cdf36926820d2efcf019ed1a1e66cbc2470b86a28606a00497eb842bd2e495b1"
  head "https://github.com/OpenVisualCloud/SVT-AV1.git"

  head do
    url "https://github.com/OpenVisualCloud/SVT-AV1.git"
  end

  stable do
    version "0.5.0"
    patch do
      url "https://raw.githubusercontent.com/1480c1/homebrew-SVT-encoders/master/patches/SVT-AV1/0001-CMakeLists-Remove-mavx-and-apply-correct-cflags.patch"
      sha256 "57d24958c13460a397d827ad4d6a94e4914806e43e73440317703c45a3d05d56"
    end
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    mkdir "_build" do
      system "cmake", "..", *std_cmake_args,
                      "-DNATIVE=OFF"
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
      system "#{bin}/SvtAv1EncApp", "-enc-mode","8",
                                    "-i", "bus_qcif_15fps.y4m",
                                    "-b", "bus_qcif_15fps.ivf"
    end
  end
end