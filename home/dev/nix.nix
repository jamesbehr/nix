{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.nix;
in
{
  options.jb.dev.nix = { enable = mkEnableOption "nix configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        rnix-lsp
        nixpkgs-fmt
      ];

      sessionVariables = { };

      sessionPath = [
      ];
    };
  };
}
