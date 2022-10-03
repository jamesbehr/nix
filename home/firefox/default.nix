{ pkgs, inputs, system, ... }:

{
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      bitwarden
    ];
    profiles = {
      default = {
        id = 0;
        name = "Default";
        isDefault = true;
        settings = {
          "network.IDN_show_punycode" = true;
          "browser.startup.page" = 3; # Restore previous tabs and windows on startup
          "browser.aboutConfig.showWarning" = false;
          "signon.rememberSignons" = false; # Don't ask to save passwords
        };
      };
    };
  };
}
