{ config, pkgs, systemSettings, userSettings, ... }: {
  # Home Manager configuration

  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  # Enable home-manager
  programs.home-manager.enable = true;

  # Add your home configurations here
  # Example:
  programs.git = {
    enable = true;
    userName = "loris";
    userEmail = "karthikn.balasubramanian@gmail.com";
    extraConfig = {
        init.defaultBranch = "main";
    };
  };

  programs.fzf = {
    enable = true;
#     enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    hello
    htop
  ];

  # Required for home-manager
  home.stateVersion = "24.11"; # Use your NixOS version
}
