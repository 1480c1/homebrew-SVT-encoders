class SvtAv1 < Formula
  desc "Multicore AV1 Encoder from OpenVisualCloud"
  homepage "https://github.com/OpenVisualCloud/SVT-AV1"

  head "https://github.com/OpenVisualCloud/SVT-AV1.git"

  stable do
    url "https://github.com/OpenVisualCloud/SVT-AV1/archive/v0.5.0.tar.gz"
    sha256 "cdf36926820d2efcf019ed1a1e66cbc2470b86a28606a00497eb842bd2e495b1"
    patch do
      url "https://raw.githubusercontent.com/1480c1/homebrew-SVT-encoders/master/patches/SVT-AV1/0001-CMakeLists-Prepare-0.5.0-for-packaging.patch"
      sha256 "cdd15599d3b16201af4c1ee5e8d7a8503248fc586da33df2b8844e63161db07b"
    end
    patch do
      url "https://raw.githubusercontent.com/1480c1/homebrew-SVT-encoders/master/patches/SVT-AV1/0002-Synonyms-only-use-avx-functions-if-MSVC.patch"
      sha256 "f1d41ca092859b8f592a550eb6816a761b1d43db45e63d7f1de216c65c75f551"
    end
    patch do
      url "https://raw.githubusercontent.com/1480c1/homebrew-SVT-encoders/master/patches/SVT-AV1/0003-IntroPrediction_Intrinsic_AVX2-only-use-avx-function.patch"
      sha256 "6e04f44553b9a75a7d01bb058a817bc075195fc00915b71ed98a9de2043f2ce1"
    end
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    mkdir "_build" do
      system "cmake", "..", *std_cmake_args
      if build.head?
        args = %W[
          -DBUILD_TESTING=OFF
          -DNATIVE=OFF
        ]
      end
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
