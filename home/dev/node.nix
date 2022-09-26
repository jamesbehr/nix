{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.node;
in
{
  options.jb.dev.node = { enable = mkEnableOption "node configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nodejs
        yarn
      ];

      sessionVariables = { };

      sessionPath = [
      ];
    };
  };
}
