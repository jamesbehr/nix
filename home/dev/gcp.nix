{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.gcp;
in
{
  options.niks.dev.gcp = { enable = mkEnableOption "Google Cloud Platform configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        google-cloud-sdk
      ];

      sessionVariables = { };

      sessionPath = [ ];

      shellAliases = { };
    };
  };
}
