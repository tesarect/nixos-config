{

  description = "Initial Flake";
  # Trying out module setup

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, ... }@inputs:
    let
      systemSettings = {
        system = "x86_64-linux";
        hostname = "nixos";
      };
      userSettings = {
        username = "arvindh";
        dotfilesDir = "~/.dotfiles";
      };

      system = systemSettings.system;
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${systemSettings.system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${systemSettings.system};

    in {
    nixosConfigurations = {
      system = lib.nixosSystem {
        system = systemSettings.system;
        specialArgs = {
          inherit systemSettings;
          inherit userSettings;
          inherit pkgs-unstable;
        };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
            {
                home-manager.users.${userSettings.username} = import ./home.nix;
                home-manager.extraSpecialArgs = { inherit systemSettings userSettings pkgs-unstable; };
                home-manager = {
                  sharedModules = [ nixvim.homeManagerModules.nixvim ];
                  users.user = {
                    programs.nixvim = {
                      enable = true;
                      package = nixpkgs-unstable.nixvim;
                    };
                  };
                };
              };
            }
          ];
      };
    };
  };
}
