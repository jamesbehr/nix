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

  home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";

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
        "waybar"
      ];
      general = {
        gaps_in = 5;
        gaps_out = 10;
        resize_on_border = true;
      };
      input = {
        follow_mouse = 2;
      };
      misc = {
        disable_hyprland_logo = true;
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
      };

      listeners = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  home.file.".wallpapers".source = ./wallpapers;

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["~/.wallpapers/pink-metal-board.webp"];
      wallpaper = [",~/.wallpapers/pink-metal-board.webp"];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 10;
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];
    };
  };

  programs.rofi.enable = true;

  services.fluidsynth = {
    enable = true;
    soundService = "pipewire-pulse";
  };
}
