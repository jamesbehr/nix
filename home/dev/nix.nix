{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.nix;
in
{
  options.niks.dev.nix = { enable = mkEnableOption "nix configuration"; };

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
