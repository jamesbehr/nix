# Nix System configuration
My system configuration and dotfiles for my Unix systems.

## Installation
### NixOS
To automatically select the correct configuration based on your hostname, just
run the following using the repository root as your working directory.

    sudo nixos-rebuild switch --flake .

### macOs
To get started, an installation of Nix is required.

    curl -L https://nixos.org/nix/install | sh

Now clone the repository.

    git clone ssh://git@github.com/jamesbehr/niks ~/.config/darwin

The nix-darwin installer doesn't work with flakes out of the box, so you can
bootstrap it.

    cd ~/.config/darwin
    nix build --extra-experimental-features flakes --extra-experimental-features nix-command .\#darwinConfigurations.manhattan.system
    ./result/sw/bin/darwin-rebuild switch --flake ~/.config/darwin

Afterwards, you can update the configuration by running the following using the
repository root as your working directory.

    darwin-rebuild switch --flake .

### Live CD
You can build the custom ISO by running the following command using the
repository root as your working directory.

    nix build .#nixosConfigurations.iso.config.system.build.isoImage

This will create an installation image which you can use to create a bootable
flash drive.

    dd status=progress bs=1M if=./result/iso/nixos-*.iso of=/dev/disk/by-id/<flashdrive>

## Hosts
| Hostname    | OS    | Description              |
|-------------|-------|--------------------------|
| `mojito`    | NixOS | Primary desktop system   |
| `manhattan` | macOS | 2019 15-inch MacBook Pro |

## Resources
### Manuals
- [Nix](https://nixos.org/manual/nix/stable/)
- [NixOS](https://nixos.org/manual/nixos/stable/)
- [Home Manager](https://nix-community.github.io/home-manager/)
- [Home Manager Appendix](https://rycee.gitlab.io/home-manager/options.html)

### Reference
- [NixOS Modules](https://nixos.wiki/wiki/NixOS_modules)

### Flakes
- Introduction to Flakes by Eelco Dolstra
  - [Part 1](https://www.tweag.io/blog/2020-05-25-flakes)
  - [Part 2](https://www.tweag.io/blog/2020-06-25-eval-cache)
  - [Part 3](https://www.tweag.io/blog/2020-07-31-nixos-flakes)
- [NixOS Wiki](https://nixos.wiki/wiki/Flakes)
- [Home Manager](https://nix-community.github.io/home-manager/index.html#sec-flakes-nixos-module)

### Configurations
- https://gitlab.com/liketechnik/nixos-files
- https://github.com/srid/nixos-config
- https://github.com/EdenEast/nyx
