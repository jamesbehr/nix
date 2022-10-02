{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.qmk;
in
{
  options.jb.dev.qmk = { enable = mkEnableOption "qmk configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        qmk
        gcc-arm-embedded
      ];

      sessionVariables = { };

      sessionPath = [ ];
    };
  };
}
