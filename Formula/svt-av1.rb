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

  bottle do
    root_url "https://github.com/1480c1/homebrew-SVT-encoders/releases/download/bottle"
    cellar :any
    sha256 "b93dea0337e03989ca4578a81e055c732a67a16afb75c98992928243940f6457" => :mojave
    sha256 "3344c5bf42e1aa071b473a0389ad08d012aefad40a6c9de1862c5d37ca124249" => :high_sierra
    sha256 "94bc088243c4435f2f5a61b7886ae363fddd2869f00cd710e32224d8f24454cd" => :sierra
    sha256 "845608ff7036bb025ac1ad6afc09eb021fcce9e43d13e36f65abc7e8de6ef24f" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    mkdir "_build" do
      args = ["-DBUILD_TESTING=OFF", "-DNATIVE=OFF"] if build.head?
      system "cmake", "..", *std_cmake_args
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
