{ lib, pkgs, ... }:

let
  workspaces = (map toString (lib.range 0 9));
in
{
  home.packages = with pkgs; [
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
        "SUPER SHIFT,c,killactive"
        "SUPER SHIFT,q,exit"
        "SUPER SHIFT,l,exec,pkill --signal SIGUSR1 swayidle"
        "SUPER,h,movecurrentworkspacetomonitor,l"
        "SUPER,j,movecurrentworkspacetomonitor,d"
        "SUPER,k,movecurrentworkspacetomonitor,u"
        "SUPER,l,movecurrentworkspacetomonitor,r"
      ] ++
      (map (n: "SUPER, ${n}, workspace, ${n}") workspaces) ++
      (map (n: "SUPER SHIFT, ${n}, movetoworkspace, ${n}") workspaces);

      # Allow these binds to work while the screen is locked
      bindl = [
        "SUPER,F1,exec,ddcutil --bus 8 --async setvcp 60 0x1b && ddcutil --bus 7 --async setvcp 60 0x11"
        "SUPER,F2,exec,ddcutil --bus 8 --async setvcp 60 0x11 && ddcutil --bus 7 --async setvcp 60 0x1b"
      ];

      exec-once = [
        "wpaperd"
        "waybar"
      ];
      general = {
        gaps_in = 5;
        gaps_out = 10;
      };
      input = {
        follow_mouse = 2;
      };
      misc = {
        disable_hyprland_logo = true;
      };
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
      {
        timeout = 600;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };

  programs.rofi.enable = true;
  programs.swaylock.enable = true;

  services.fluidsynth = {
    enable = true;
    soundService = "pipewire-pulse";
  };
}
