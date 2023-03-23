{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.haskell;
in
{
  options.niks.dev.haskell = { enable = mkEnableOption "haskell configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        ghc
        haskell-language-server
      ];
    };
  };
}
