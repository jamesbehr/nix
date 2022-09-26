{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.ruby;
in
{
  options.jb.dev.ruby = { enable = mkEnableOption "ruby configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        ruby
        bundler
        rubyPackages.solargraph
      ];

      sessionVariables = { };

      sessionPath = [
      ];
    };
  };
}
