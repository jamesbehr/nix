{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.lua;
in
{
  options.jb.dev.lua = { enable = mkEnableOption "lua configuration"; };

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
