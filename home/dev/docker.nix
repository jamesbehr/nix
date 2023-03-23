{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.docker;
in
{
  options.niks.dev.docker = { enable = mkEnableOption "docker configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        docker
        docker-compose
      ];

      sessionVariables = { };

      sessionPath = [ ];

      shellAliases = {
        dk = "docker";
        dc = "docker-compose";
      };
    };
  };
}
