{ config, lib, pkgs, ... }:

with lib;
let cfg = config.jb.dev.scala;
in
{
  options.jb.dev.scala = { enable = mkEnableOption "scala configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        scala-cli
        sbt
        metals
        scalafmt
        coursier
      ];

      shellAliases = {
        scala = "scala-cli";
      };
    };
  };
}
