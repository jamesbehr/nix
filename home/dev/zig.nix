{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.zig;
in
{
  options.niks.dev.zig = { enable = mkEnableOption "zig configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        zig
        zls
      ];
    };
  };
}
