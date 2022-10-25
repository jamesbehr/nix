{ pkgs, ... }:

{
  home.packages = with pkgs; [
    feh
    spotdl
    audacity
    reaper
  ];

  services = {
    network-manager-applet = {
      enable = true;
    };

    udiskie = {
      enable = true;
    };

    pasystray = {
      enable = true;
    };

    blueman-applet = {
      enable = true;
    };
  };

  systemd.user.services.feh = {
    Unit = {
      Description = "Wallpaper service";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      ExecStart = "${pkgs.feh}/bin/feh --bg-scale --randomize %h/Pictures/wallpapers";
      Restart = "no";
    };
  };

  xsession = {
    preferStatusNotifierItems = true;
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };
  };

  xdg.configFile."taffybar/taffybar.hs".source = ./taffybar.hs;
  services = {
    taffybar.enable = true;
    status-notifier-watcher.enable = true;
  };

  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    shadow = true;
    shadowOpacity = 0.75;
    shadowExclude = [
      "class_g = 'Taffybar'"
    ];

    settings = {
      corner-radius = 7.0;
      detect-rounded-corners = true;
      rounded-corners-exclude = [
        "window_type = 'menu'"
        "window_type = 'dropdown_menu'"
        "window_type = 'popup_menu'"
        "window_type = 'utility'"
        "class_g = 'Taffybar'"
        "class_g = 'Rofi'"
        "class_g = 'Dunst'"
      ];
    };
  };

  services.fluidsynth = {
    enable = true;
    soundService = "pulseaudio";
  };
}
