{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.k8s;
in
{
  options.niks.dev.k8s = { enable = mkEnableOption "kubernetes configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        kubectl
        kubernetes-helm
      ];

      sessionVariables = { };

      sessionPath = [ ];

      shellAliases = { };
    };
  };
}
