{ config, pkgs, ... }:
let
  SHELL_ALIASES = {
    ll   = "ls -l";
    ".." = "cd ..";
    # Listing
#     lsosgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
#     lshmgen = "home-manager generations";
#     nixenvlsgen = "nix-env --list-generations";
#     # Switch to modified gen
#     hmswflk = "home-manager swtch --flake ~/.dotfiles/";
#     nixosrebldswitchflake = "sudo nixos-rebuild switch --flake .";
    nvf = "nvim";
  };
in
{
  programs.bash = {
    enable = true;
    shellAliases = SHELL_ALIASES;
  };

  programs.zsh = {
    enable = true;
    shellAliases = SHELL_ALIASES;
    autosuggestion.enable = true;

    initContent = ''
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    zplug = {
      enable = true;
      plugins = [
        #{ name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; } # powerline10k
      ];
    };
  };
}
