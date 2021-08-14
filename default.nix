# This piece of code goes to public domain

{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  perl5lib = perlPackages.makeFullPerlPath [ perlPackages.NetHTTPSNB perlPackages.YAMLSyck ];
in
stdenv.mkDerivation rec {
  name = "kdesrc-build-${version}";
  version = "20.06";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "SDK";
    repo = "kdesrc-build";
    rev = "v${version}";
    sha256 = "GNbGA+5b//4+R7w7Wy+yJ4nKPnosoTKo8wpKDcy9eOI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/
    wrapProgram $out/bin/kdesrc-build \
                --prefix PATH : ${lib.makeBinPath [ perl ]} \
                --set PERL5LIB ${perl5lib}
    wrapProgram "$out/bin/kdesrc-build-setup" \
                --prefix PATH : ${lib.makeBinPath [ dialog perl ]}
  '';
}
