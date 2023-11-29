{ config, lib, pkgs, ... }:

with lib;
let cfg = config.niks.dev.gcp;
in
{
  options.niks.dev.gcp = { enable = mkEnableOption "Google Cloud Platform configuration"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        (google-cloud-sdk.withExtraComponents [
          google-cloud-sdk.components.gke-gcloud-auth-plugin
          google-cloud-sdk.components.pubsub-emulator
        ])
      ];

      sessionVariables = {
        USE_GKE_GCLOUD_AUTH_PLUGIN = "True"; # remove after kubectl v1.26
      };

      sessionPath = [ ];

      shellAliases = { };
    };
  };
}
