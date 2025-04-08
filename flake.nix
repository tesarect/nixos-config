{

    description = "Initial flake";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        nvf.url = "github:notashelf/nvf";

    };

    outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, nvf, ... }@inputs:
        let
            systemSettings = {
                system = "x86_64-linux";
                hostname = "ophidian";
            };
            userSettings = {
                username = "loris";
                dotfilesDir = "~/.dotfiles";
            };

            lib = nixpkgs.lib;
            system = systemSettings.system;
            pkgs = nixpkgs.legacyPackages.${systemSettings.system};
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${systemSettings.system};

        in {
        # nvf standalone setup
        packages.${system}.default =
        (nvf.lib.neovimConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
                ./editors/nvf/nvf.nix
            ];
        }).neovim;

        nixosConfigurations = {
            ophidian = lib.nixosSystem {
#                 system = systemSettings.system;
                specialArgs = {
                    inherit systemSettings;
                    inherit userSettings;
                    inherit pkgs-unstable;
                };
                modules = [
                    ./configuration.nix
                    nvf.nixosModules.default    # nvf
                    home-manager.nixosModules.home-manager
                    {
                        home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.${userSettings.username} = import ./home.nix;

                        extraSpecialArgs = {
                            inherit systemSettings userSettings pkgs-unstable inputs;
                            };
                        };
                    }
                ];
            };
        };
    };

}
