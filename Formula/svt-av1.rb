class SvtAv1 < Formula
  desc "Multicore AV1 Encoder from OpenVisualCloud"
  homepage "https://github.com/OpenVisualCloud/SVT-AV1"
  url "https://github.com/1480c1/SVT-AV1.git",
      :branch   => "xsave",
      :revision => "a650a74ad68d18d687c58de2cc0e5170785855b6"
  # It's just v0.5.0 with patches applied to the cmakelists
  # to remove unecessary and add necessary cflags for building properly.
  # Fixed in HEAD and in the next release.
  version "0.5.0"
  head "https://github.com/OpenVisualCloud/SVT-AV1.git"

  bottle do
    root_url "https://dl.bintray.com/1480c1/bottles-svt-encoders"
    cellar :any
    sha256 "a134161fea544ea2a22598b9fea129679d3e81642ea6f440dfc0398db3eabb49" => :mojave
    sha256 "44fb1a337c5b37ab44ecc2354d25404cf049a43cfd59488b677fb99c03eeab4a" => :high_sierra
    sha256 "c321aab1a1f5399f46a513335cd119062e16ca7872e2efb5deca6a75618e9675" => :sierra
    sha256 "44595406b044e2332e40eefdb26cd3e534cf326cbeb66c6e3b84429d65b835c8" => :x86_64_linux
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
