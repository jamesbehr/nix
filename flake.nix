{
  description = "James's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, nur }: {
    nixosConfigurations = {
      iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      };

      mojito = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixpkgs; };
        modules = [
          ./hosts/mojito
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [
              nur.overlay
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.james = { pkgs, ... }: {
              imports = [
                ./home/neovim
                ./home/shell
                ./home/firefox
                ./home/terminal
                ./home/dev
                ./home/desktop
              ];
              home.stateVersion = "22.05";
              niks.user = {
                name = "James Behr";
                email = "jamesbehr@gmail.com";
              };
              niks.dev = {
                haskell.enable = true;
                go.enable = true;
                python.enable = true;
                rust.enable = true;
                node.enable = true;
                lua.enable = true;
                terraform.enable = false;
                c.enable = true;
                nix.enable = true;
                qmk.enable = true;
              };
            };
          }
        ];
      };
    };

    darwinConfigurations = {
      sidecar = darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # use "x86_64-darwin" on pre-M1 Mac
        modules = [
          ./hosts/sidecar
          {
            # This is required, otherwise your home directory is assumed to be
            # "/var/empty" which doesn't exist.
            # See https://github.com/LnL7/nix-darwin/issues/423
            users.users."james.behr".home = "/Users/james.behr";
          }
          home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = [
              nur.overlay
              (import overlays/firefox.nix)
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."james.behr" = { pkgs, ... }: {
              imports = [
                ./home/neovim
                ./home/shell
                ./home/dev
                ./home/terminal
                ./home/firefox
              ];
              home.stateVersion = "22.05";
              niks.user = {
                name = "James Behr";
                email = "james.behr@takealot.com";
              };
              niks.dev = {
                terraform.enable = true;
                docker.enable = true;
                k8s.enable = true;
                gcp.enable = true;
                ruby.enable = true;
                nix.enable = true;
                scala.enable = true;
                go.enable = true;
              };
            };
          }
        ];
      };
    };
  };
}
