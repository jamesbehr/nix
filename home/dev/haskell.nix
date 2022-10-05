{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.haskell;
in
{
  options.jb.dev.haskell = { enable = mkEnableOption "haskell configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        ghc
        haskell-language-server
      ];
    };
  };
}
