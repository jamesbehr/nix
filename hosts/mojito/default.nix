{ config, pkgs, modulesPath, lib, nixpkgs, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sdhci_pci"
    "uas"
    "usbcore"
    "vfat"
    "nls_cp437"
    "nls_iso8859_1"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "i2c-dev" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=root" "noatime" ];
    };

  boot.initrd.systemd = {
    enable = true;
    mounts = [
      {
        what = "/dev/disk/by-label/usbkey";
        where = "/key";
        type = "vfat";
        options = "ro,nofail";
      }
    ];
  };

  boot.initrd.luks.devices."root" = {
    keyFile = "/key/root.key";
    device = "/dev/disk/by-label/root";
    keyFileTimeout = 10;
  };

  boot.initrd.luks.devices."sata" = {
    keyFile = "/key/sata.key";
    device = "/dev/disk/by-label/sata";
    crypttabExtraOpts = [ "nofail" ];
    keyFileTimeout = 10;
  };

  fileSystems."/mnt/media" =
    {
      device = "/dev/disk/by-label/media";
      fsType = "ext4";
      options = [ "nofail" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=home" "noatime" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Flake support
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # For compatibility with nix-shell, nix-build, etc.
    nixPath = [
      "nixpkgs=/etc/nixpkgs"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    registry.nixpkgs.flake = nixpkgs;
  };

  # Pass flake nixpkgs through to /etc/nixpkgs
  environment.etc.nixpkgs.source = nixpkgs;

  systemd.services.NetworkManager-wait-online.enable = false;

  # Networking
  networking.hostName = "mojito";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs.hyprland.enable = true;

  services.gnome.at-spi2-core.enable = true;
  services.dbus.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Virtualization
  virtualisation.docker.enable = true;

  users.groups.media = {
    members = [
      "jackett"
      "sonarr"
      "radarr"
      "plex"
      "james"
      "nzbget"
    ];
  };

  # ddcutil
  users.groups.i2c = {
    members = [
      "james"
    ];
  };

  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    KERNEL=="uinput", GROUP="input", MODE="0660"
  '';

  services.nzbget = {
    enable = true;
    group = "media";
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
  };

  services.jackett = {
    enable = true;
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  services.k3s.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # services.jack = {
  #   jackd = {
  #     enable = true;
  #     extraOptions = [ "-dalsa" "-dhw:CODEC,0" "-r48000" "-p64" "-n2" ];
  #   };
  #   alsa.enable = false;
  #   loopback = {
  #     enable = true;
  #   };
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.james = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "jackaudio" "dialout" "docker" ];
    description = "James";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "james" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    ddcutil
    man-pages
    man-pages-posix
  ];

  nixpkgs.config.allowUnfree = true;

  documentation.dev.enable = true;
  documentation.man.generateCaches = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
