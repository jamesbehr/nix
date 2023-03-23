{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.node;
in
{
  options.niks.dev.node = { enable = mkEnableOption "node configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nodejs
        yarn
        nodePackages.typescript-language-server
      ];

      sessionVariables = { };

      sessionPath = [
      ];
    };
  };
}
