{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.niks.desktop.kitty;
in {
  options.niks.desktop.kitty = { enable = mkEnableOption "Kitty Terminal Emulator"; };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "Cascadia Code";
        package = pkgs.cascadia-code;
        size = 11;
      };

      themeFile = "Duskfox";

      settings = {
        enable_audio_bell = false;
      };
    };
  };
}
