# Nix System configuration
My system configuration and dotfiles for my Unix systems.

## Installation
### NixOS
To automatically select the correct configuration based on your hostname, just
run the following using the repository root as your working directory.

    sudo nixos-rebuild switch --flake .

### macOs
See the [docs](https://github.com/LnL7/nix-darwin) for installation
instructions. Afterwards, you can update the configuration by running the
following using the repository root as your working directory.

    darwin-rebuild switch --flake .

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
