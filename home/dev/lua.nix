{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.lua;
in
{
  options.niks.dev.lua = { enable = mkEnableOption "lua configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        sumneko-lua-language-server
      ];

      sessionVariables = { };

      sessionPath = [
      ];
    };
  };
}
