{

  description = "Initial Flake";
  # Trying out module setup

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs = {
              self,
              nixpkgs,
              nixpkgs-unstable,
              home-manager,
              sops-nix,
              nvf,
              ghostty,
              ...
            }@inputs:
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
      sopsHmModule = sops-nix.homeManagerModules.sops-nix;

    in {

    # nvf as standalone
    packages.${systemSettings.system}.nvim =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.${systemSettings.system};
        modules = [ ./editors/nvf/default.nix];
      }).neovim;

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
          ./users/guest     # just a junk user
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          ({ pkgs, ... }: {
            environment.systemPackages = [
              ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
          })
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${userSettings.username} = import ./home.nix;
              extraSpecialArgs = {
                inherit systemSettings userSettings pkgs-unstable inputs;
              };
              sharedModules = [ sops-nix.homeManagerModules.sops ];
            };
          }
        ];
      };
    };
  };
}
