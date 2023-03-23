{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.scala;
in
{
  options.niks.dev.scala = { enable = mkEnableOption "scala configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        scala-cli
        sbt
        metals
        scalafmt
        coursier
      ];
    };
  };
}
