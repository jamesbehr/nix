{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.niks.desktop.browser;
in {
  options.niks.desktop.browser = { enable = mkEnableOption "Browser"; };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };

    programs.firefox = {
      enable = true;
      # Firefox is installed via Homebrew on macOS
      package = if pkgs.stdenv.isLinux then pkgs.firefox else null;
      profiles = {
        default = {
          id = 0;
          name = "Default";
          isDefault = true;
          settings = {
            "network.IDN_show_punycode" = true; # Protect against domain spoofing in internationalized domains
            "browser.startup.page" = 3; # Restore previous tabs and windows on startup
            "browser.aboutConfig.showWarning" = false;
            "signon.rememberSignons" = false; # Don't ask to save passwords
            "media.eme.enabled" = true; # Enable DRM
          };
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            darkreader
          ];
        };
      };
    };
  };
}
