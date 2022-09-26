{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.terraform;
in
{
  options.jb.dev.terraform = { enable = mkEnableOption "terraform configuration"; };

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
