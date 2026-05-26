# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, systemSettings, userSettings, ... }:
# { config, pkgs, systemSettings, userSettings, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hosts.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 25;

  # Session Variables
  environment.sessionVariables = {
    NH_FLAKE = "/home/${userSettings.username}/.dotfiles";
    # for Electron apps (Discord, VSCode, Brave, etc.) on Wayland, you may also want:
    NIXOS_OZONE_WL = "1";
  };

  # Shell - zsh as default
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  networking.hostName = systemSettings.hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Set your time zone
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Automatic updating
  system.autoUpgrade.enable = false;
  system.autoUpgrade.dates = "weekly";

  # Auto Cleaning
  nix.gc.automatic = false;
  nix.gc.dates = "daily";
#   nix.gc.options = "--delete-older-than 200d"; # next change it to 60 days
  # Garbage collections
  nix.settings.auto-optimise-store = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # ----trying to see is DBus service allows application to query
  services.udisks2.enable = true;
  services.fwupd.enable = true;

  # Enable the KDE Plasma Desktop Environment.
#   services.xserver.displayManager.sddm.enable = true;   warning - option change
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
#   services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
#     layout = "us";    warning - option change
    xkb.layout = "us";
#     xkbVariant = "";  warning - option change
    xkb.variant = "";
  };
  # explicitly enable graphics stack - important on newer NixOS
  hardware.graphics.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Bluetooth Services
  hardware.bluetooth.enable = true;  # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;

  # Enable sound with pipewire.
#   sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # for screen recording
  services.pipewire.extraConfig.pipewire."91-null-sinks" = {
    "context.objects" = [
      {
        # A default dummy driver. This handles nodes marked with the "node.always-driver"
        # properyty when no other driver is currently active. JACK clients need this.
        factory = "spa-node-factory";
        args = {
          "factory.name"     = "support.node.driver";
          "node.name"        = "Dummy-Driver";
          "priority.driver"  = 8000;
        };
      }
      {
        factory = "adapter";
        args = {
          "factory.name"     = "support.null-audio-sink";
          "node.name"        = "Microphone-Proxy";
          "node.description" = "Microphone";
          "media.class"      = "Audio/Source/Virtual";
          "audio.position"   = "MONO";
        };
      }
      {
        factory = "adapter";
        args = {
          "factory.name"     = "support.null-audio-sink";
          "node.name"        = "Main-Output-Proxy";
          "node.description" = "Main Output";
          "media.class"      = "Audio/Sink";
          "audio.position"   = "FL,FR";
        };
      }
    ];
  };
  #-------------------------------------------------------
  services.pipewire.extraConfig.pipewire-pulse."92-low-latency" = {
  context.modules = [
    {
      name = "libpipewire-module-protocol-pulse";
      args = {
        pulse.min.req = "32/48000";
        pulse.default.req = "32/48000";
        pulse.max.req = "32/48000";
        pulse.min.quantum = "32/48000";
        pulse.max.quantum = "32/48000";
        };
      }
    ];
  stream.properties = {
      node.latency = "32/48000";
      resample.quality = 1;
    };
  };

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];



  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.username;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kdePackages.kate # need to fine alternative before 25.11 as its using Qt5
      git
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # virt-manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [userSettings.username];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # services.teamviewer.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
  ( with pkgs; [
    # list of unstable packages
    ghostty
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wl-clipboard
    maliit-keyboard
    wget
    neofetch
    kdiff3
    kdePackages.kompare

    # display (wireless display)
#     gnome-network-displays
#     xdg-desktop-portal-gnome
#     kdePackages.plasma-nm

    # Office suit
    libreoffice

    labplot

    # Browser
    brave

    # Utilities
    fd      # fast and user-friendly alternative to find
    yazi    # fast terminal file manager written in Rust

    # --TEMP
    #teamviewer
    piper-tts

    unzip
    unrar
    usbutils
    pciutils
    curl
    gittyup
    jre_minimal
    home-manager
    # nix helpers
    nix-output-monitor
    nvd
    # LSP for nix
    nixd
    # hardinfo2
    # Media
    vlc
    ffmpeg
    #ytmdesktop
    gimp
    virt-manager
  ])
  ++
  ( with pkgs-unstable; [
    # list of unstable packages
    # nix helpers
    nh
  ]);

  fonts.packages = with pkgs; [
#     nerd-fonts.symbols-only
    font-awesome
    powerline-fonts
  ];
  fonts.fontconfig.enable = true;

  # wireless display
  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  xdg.portal.extraPortals = [
#     pkgs.xdg-desktop-portal-gnome
#     pkgs.xdg-desktop-portal-wlr   # if you’re on a wl roots environment
   pkgs.kdePackages.xdg-desktop-portal-kde
  ];
  networking.firewall = {
    trustedInterfaces = [ "p2p-wl+" ];   # allow WiFi-P2P interfaces
    allowedTCPPorts = [ 7236 7250 ];
    allowedUDPPorts = [ 7236 5353 ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon. {for other meachine to ssh into this machine}
  # services.openssh.enable = true;

  # Open ports in the firewall. - to control outgoing or incomming connections.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
