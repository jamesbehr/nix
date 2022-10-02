{
  description = "James's system configuration";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur }: {
    nixosConfigurations = {
      mojito = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
              ];
              home.stateVersion = "22.05";
              jb.dev = {
                go.enable = true;
                python.enable = true;
                node.enable = true;
                lua.enable = true;
                terraform.enable = true;
                c.enable = true;
                qmk.enable = true;
              };
            };
          }
        ];
      };
    };
  };
}
