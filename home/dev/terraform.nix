{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.terraform;
in
{
  options.niks.dev.terraform = { enable = mkEnableOption "terraform configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        terraform
        terraform-ls
      ];

      sessionVariables = { };

      sessionPath = [ ];

      shellAliases = {
        tf = "terraform";
      };
    };
  };
}
