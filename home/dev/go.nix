{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.go;
in
{
  options.niks.dev.go = { enable = mkEnableOption "go configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        go
        go-tools
        gopls
        gotestsum
      ];

      sessionVariables = {
        GOPATH = "${config.home.homeDirectory}/go";
        GOBIN = "${config.home.homeDirectory}/go/bin";
      };

      sessionPath = [
        "${config.home.homeDirectory}/go/bin"
      ];
    };
  };
}
