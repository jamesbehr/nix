{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.python;
in
{
  options.jb.dev.python = { enable = mkEnableOption "python configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        python39
      ];

      sessionVariables = { };

      sessionPath = [ ];

      shellAliases = {
        py = "python";
      };
    };
  };
}
