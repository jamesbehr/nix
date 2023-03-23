{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.ruby;
in
{
  options.niks.dev.ruby = { enable = mkEnableOption "ruby configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        ruby
        rubyPackages.solargraph
      ];

      sessionVariables = { };

      sessionPath = [
      ];
    };
  };
}
