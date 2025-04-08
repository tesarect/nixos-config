    { config, pkgs, ... }:
let
  SHELL_ALIASES = {
    ll   = "ls -l";
    ".." = "cd ..";
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
#     enableAutosuggestions = true;
    autosuggestion.enable = true;

    initExtra = ''
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    # With Antidote - a plugin manager (i guess)
    antidote = {
    enable = true;
    plugins = [''
      zsh-users/zsh-autosuggestions
      ohmyzsh/ohmyzsh path:lib/git.zsh
    '']; # explanation of "path:..." and other options explained in Antidote README.

    # Manual
    plugins = [
    {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
            owner = "marlonrichert";
            repo = "zsh-autocomplete";
            rev = "23.07.13";
            sha256 = "sha256-/6V6IHwB5p0GT1u5SAiUa20LjFDSrMo731jFBq/bnpw=";
        };
        }
        {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
        }
        {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.8.0";
            sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
        }
    ];
    };

  };
}
