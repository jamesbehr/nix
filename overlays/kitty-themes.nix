final: prev:

{
  kitty-themes = prev.kitty-themes.overrideAttrs (
    old: {
      version = "0-unstable-2024-10-17";

      src = prev.fetchFromGitHub {
        owner = "kovidgoyal";
        repo = "kitty-themes";
        rev = "acf00563f8bc578634ddd9127f31810efabbdc58";
        hash = "sha256-ktu595EGCa3BFjxmK8ofdAOFM4fODAd+MaFQsBDwDu0=";
      };
    }
  );
}
