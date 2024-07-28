{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.aws;
in
{
  options.niks.dev.aws = { enable = mkEnableOption "AWS configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        awscli2
      ];

      sessionPath = [ ];

      shellAliases = { };
    };
  };
}
