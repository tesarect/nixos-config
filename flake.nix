{

    description = "Initial flake";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

    };

    outputs = {self, nixpkgs, home-manager, ... }:
        let
            lib = nixpkgs.lib;
            systemSettings = {
                system = "x86_64-linux";
                hostname = "ophidian";
            };
            userSettings = {
                username = "loris";
                dotfilesDir = "~/.dotfiles";
            };
        in {
        nixosConfigurations = {
            ophidian = lib.nixosSystem {
                system = systemSettings.system;
                specialArgs = {
                    inherit systemSettings;
                    inherit userSettings;
                };
                modules = [
                    ./configuration.nix
                    home-manager.nixosModules.home-manager
                    {
                        home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.${userSettings.username} = import ./home.nix;

                        extraSpecialArgs = {
                            inherit systemSettings userSettings;
                            };
                        };
                    }
                ];
            };
        };
    };

}
