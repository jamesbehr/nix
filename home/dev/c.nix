{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.c;
in
{
  options.jb.dev.c = { enable = mkEnableOption "C/C++ configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        gcc
        gnumake
        clang-tools
      ];

      sessionVariables = { };

      sessionPath = [
      ];
    };
  };
}
