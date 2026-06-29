{ config, pkgs, systemSettings, userSettings, inputs, sopsNixHmModule, ... }:

let

  legacyPkgs = import (fetchTarball {

    # V 1.7.3
    #url = "https://github.com/NixOS/nixpkgs/archive/55070e598e0e03d1d116c49b9eff322ef07c6ac6.tar.gz";
    #sha256 = "1s34wcx14klzcvxwhfdyx4hq2q2rfzk6lgivr5mw6bi2mxn5844f";

    # V 1.8.3
    #url = "https://github.com/NixOS/nixpkgs/archive/459104f841356362bfb9ce1c788c1d42846b2454.tar.gz";
    #sha256 = "1s34wcx14klzcvxwhfdyx4hq2q2rfzk6lgivr5mw6bi2mxn5844f";

    # V 1.8.4
    #url = "https://github.com/NixOS/nixpkgs/archive/7a339d87931bba829f68e94621536cad9132971a.tar.gz";
    #sha256 = "1w4zyrdq7zjrq2g3m7bhnf80ma988g87m7912n956md8fn3ybhr4";

    # V 1.9.0
    #url = "https://github.com/NixOS/nixpkgs/archive/4684fd6b0c01e4b7d99027a34c93c2e09ecafee2.tar.gz";
    #sha256 = "1ajjga131kjxiw2760pjjsxpa201gzp0i6gphgg44vq496lqpcyb";

    # V 1.9.4
    #url = "https://github.com/NixOS/nixpkgs/archive/e6f23dc08d3624daab7094b701aa3954923c6bbb.tar.gz";
    #sha256 = "1s34wcx14klzcvxwhfdyx4hq2q2rfzk6lgivr5mw6bi2mxn5844f";

  }) { inherit (pkgs) system; };

in {

  imports = [
    ./sh/sh.nix
    ./term/tmux/default.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  sops = {
    age.keyFile = "/home/${userSettings.username}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets = {
      git_email = {};
      git_name = {};
    };
  };

  programs.git = {
    enable = true;
    settings.user.name = config.sops.secrets.git_name.path;
    settings.user.email = config.sops.secrets.git_email.path;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.librewolf = {
    enable = true;
    # Enable WebGL, cookies and history
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    hello
    emacs
    tmux
    htop
    pear-desktop
    discord
    pdfmixtool
    obsidian
    affine

    # Math
    qalculate-qt

    # for neovim - not sure if needed
    tree-sitter
    git
    xclip
    nodejs

    sshfs

    # networking
    nmap
    arp-scan
    wireshark
    #tshark
    termshark
    #netdiscover
    filezilla

    # temps
    #legacyPkgs.rpi-imager
    #rpi-imager

    # Add this line to use the nvf-configured neovim from your flake output
    inputs.self.packages.${systemSettings.system}.nvim

    # hardware analysis tools
    #python313Packages.sigrok
    #python312Packages.sigrok
    #smuview # QT based ui for sigrok
    #pulseview # sigrok

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
#     (pkgs.nerd-fonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    nerd-fonts.symbols-only

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  
  home.file.".p10k.zsh" = {
    source = ./p10k/.p10k.zsh;
    executable = true;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/arvindh/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
