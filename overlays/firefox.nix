# https://cmacr.ae/post/2020-05-09-managing-firefox-on-macos-with-nix/
final: prev:
{
  firefox-bin = prev.stdenv.mkDerivation
    rec {
      pname = "Firefox";
      version = "111.0";
      locale = "en-GB";

      buildInputs = [ prev.pkgs.undmg ];
      sourceRoot = ".";
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        mkdir -p $out/Applications
        cp -r Firefox*.app "$out/Applications"
      '';

      src = prev.fetchurl {
        name = "Firefox-#{version}.dmg";
        url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/${locale}/Firefox%20${version}.dmg";

        # See https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/SHA256SUMS
        sha256 = "8e547a72ba934ca39ace5332c5ee4e9b4d871bc7f3025e91471fcffba52028d2";
      };

      meta = {
        description = "The Firefox web browser";
        homepage = "https://www.mozilla.org/${locale}/firefox";
      };
    };
}
