{ pkgs, inputs, system, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Cascadia Code";
      package = pkgs.cascadia-code;
      size = 11;
    };

    theme = "Tokyo Night"; # TODO: Pick a theme

    settings = {
      enable_audio_bell = false;
    };
  };
}
