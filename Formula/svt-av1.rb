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
    sha256 "d98da74b06aec399d52be75e919aadd5c94fca223e7e3d69222b83a9cd9744f0" => :high_sierra
    sha256 "e0b7967633a2fb452d4c235af5bc87c9a6660a842ee9d1db17d4bafb81caa9d7" => :mojave
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
