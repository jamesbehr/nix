{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.qmk;
in
{
  options.niks.dev.qmk = { enable = mkEnableOption "qmk configuration"; };

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
