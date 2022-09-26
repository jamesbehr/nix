{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.go;
in
{
  options.jb.dev.go = { enable = mkEnableOption "go configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        go
        go-tools
        gopls
      ];

      sessionVariables = {
        GOPATH = "${config.xdg.dataHome}/go";
        GOBIN = "${config.xdg.dataHome}/go/bin";
      };

      sessionPath = [
        "${config.xdg.dataHome}/go/bin"
      ];
    };
  };
}
