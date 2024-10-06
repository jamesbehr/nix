{ pkgs, inputs, system, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Cascadia Code";
      package = pkgs.cascadia-code;
      size = 11;
    };

    # TODO: Switch to duskfox when it arrives in NixOS (it was already merged upstream)
    themeFile = "Nightfox";

    settings = {
      enable_audio_bell = false;
    };
  };
}
