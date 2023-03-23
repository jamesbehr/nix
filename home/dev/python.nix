{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.python;
in
{
  options.niks.dev.python = { enable = mkEnableOption "python configuration"; };

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
