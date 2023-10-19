{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.rust;
in
{
  options.niks.dev.rust = { enable = mkEnableOption "rust configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        rustup
      ];

      sessionPath = [
        "${config.home.homeDirectory}/.cargo/bin"
      ];
    };
  };
}
