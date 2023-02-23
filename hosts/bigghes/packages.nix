{ config, pkgs, lib, ... }:

{
  nixpkgs.config = {
    allowUnfree = true; # Allow non open source packages
  };

  environment.systemPackages = with pkgs; [
    any-nix-shell # Use nix shell use any shell i.e. fish
    ark
    bat
    discord
    fd
    filelight
    firefox-wayland # Until firefox moves to using wayland by default
    fzf
    git
    gnome-network-displays
    google-chrome
    helvum
    heroic
    kate
    kolourpaint
    libreoffice-qt
    logseq
    lutris
    mangohud
    micro
    mpv
    neofetch
    prismlauncher-qt5
    qbittorrent
    signal-desktop
    steam
    steam-run
    tmux
    tree
    unrar
    wget
    whatsapp-for-linux
    yakuake
    zoom-us
    # Package overrides
    (appimage-run.override {
      extraPkgs = pkgs: [  ];
    })
    # Packages from 3rd party overlays
  ];

  programs = {
    fish.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
    partition-manager.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "qt";
    };
  };

  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    fonts = with pkgs; [
      inter
      roboto
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };
}
