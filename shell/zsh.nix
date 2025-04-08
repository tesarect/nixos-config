{ config, pkgs, ... }:

{
  # Make zsh the default shell for all users
  users.defaultUserShell = pkgs.zsh;

  # Ensure these packages are available system-wide
  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
  ];

  # Enable zsh system-wide
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Your existing aliases...
      envf = "cd ~/.config/nvf && nix run .#";
      nvf = "cd ~/.dotfiles/editors/nvf && nix run .";
      # Alternative approach if you prefer:
      # nvf = "~/.local/bin/nvf";
    };

    # Default settings for all users
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
      theme = "robbyrussell"; # Default theme for users without p10k
    };

    promptInit = ''
      # Source powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Enable powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Load configuration if it exists
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Create a function to run the configuration wizard
      function p10k-config() {
        ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/gitstatus/install
        ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/p10k configure
      }

      # If p10k config doesn't exist, offer to run the wizard
      if [[ ! -f ~/.p10k.zsh ]]; then
        echo "Powerlevel10k configuration not found."
        echo "Run 'p10k-config' to create it."
      fi
    '';

    interactiveShellInit = ''
      # Define aliases
      alias p10k='p10k-config'
    '';
  };
}
