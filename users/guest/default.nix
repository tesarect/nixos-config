# guest:guest

{ config, pkgs, ... }:
{
  # Basic user account setup
  users.users.guest = {
    isNormalUser = true;
    description = "guest";
    extraGroups = [ "networkmanager" ];
  };

  # Home-manager configuration for the new user
  home-manager.users.guest = { config, pkgs, ... }: {
    # Enable home-manager for this user
    programs.home-manager.enable = true;

    # Install Firefox
    programs.firefox = {
      enable = true;
      # You can add Firefox customizations here if needed
    };

    # Basic home configuration
    home = {
      username = "guest";
      homeDirectory = "/home/guest";
#       stateVersion = config.system.stateVersion;
      stateVersion = "23.05";

      # You can add other simple packages here
      packages = with pkgs; [
        # Any additional packages for this user
        teams-for-linux
      ];
    };
  };
}
