{ lib, pkgs, ... }:

let
  workspaces = (map toString (lib.range 0 9));
in
{
  home.packages = with pkgs; [
    spotdl
    audacity
    reaper
    yabridge
    yabridgectl
    mplayer
    ghidra-bin
    wineWowPackages.stable
    winetricks
    deluge
    inkscape
    xournal
    teensyduino
    wl-clipboard
  ];

  # Start tray.target unit, which is needed for many services
  # See https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

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

  programs.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = "/home/james/Pictures/wallpapers/";
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
          "wlr/taskbar"
        ];
        modules-center = [
          "cpu"
          "memory"
          "disk"
        ];
        modules-right = [
          "tray"
          "clock"
        ];

        "clock" = {
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
        };
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      bind = [
        "SUPER,Return,exec,kitty"
        "SUPER,Space,exec,rofi -show drun"
        "SUPER,c,killactive"
        "SUPER SHIFT,q,exit"
      ] ++
      (map (n: "SUPER, ${n}, workspace, ${n}") workspaces) ++
      (map (n: "SUPER SHIFT, ${n}, movetoworkspace, ${n}") workspaces);
      monitor = [
        "DP-1, 1920x1080, 1920x0, 1"
        "DP-3, 1920x1080, 0, 1"
      ];
      exec-once = [
        "wpaperd"
        "waybar"
      ];
      general = {
        gaps_in = 5;
        gaps_out = 10;
      };
      misc = {
        disable_hyprland_logo = true;
      };
    };
  };

  programs.rofi.enable = true;
  programs.swaylock.enable = true;

  services.fluidsynth = {
    enable = true;
    soundService = "pulseaudio";
  };
}
