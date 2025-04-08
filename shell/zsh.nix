{ config, pkgs, ... }:

{
  # Enable zsh system-wide
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # Default settings for all users
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
      theme = "robbyrussell"; # Default theme for users without p10k
    };
  };

  # Make zsh the default shell for all users
  users.defaultUserShell = pkgs.zsh;

  # Ensure these packages are available system-wide
  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
  ];
}
