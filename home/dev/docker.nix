{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.docker;
in
{
  options.jb.dev.docker = { enable = mkEnableOption "docker configuration"; };

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
