{ inputs, config, pkgs, ... }:

{
  home = {
    username = "sharpie";
    homeDirectory = "/home/sharpie";
    stateVersion = "22.05";
    pointerCursor = {
      size = 24;
      gtk.enable = true;
      x11.enable = true;
      name = "breeze_cursors";
      package = pkgs.breeze-icons;
    };
    sessionVariables = { EDITOR = "micro"; };
    file = {
      # Dotfiles that can't be managed via home-manager
      ".config/starship.toml".source =
        "${inputs.dotfiles}/.config/starship.toml";
      ".config/MangoHud/MangoHud.conf".source =
        "${inputs.dotfiles}/.config/MangoHud/MangoHud.conf";
      # Autostart programs
      # Fix flatpak fonts, themes, icons and cursor
      ".icons/breeze_cursors".source = config.lib.file.mkOutOfStoreSymlink
        "/run/current-system/sw/share/icons/breeze_cursors";
      ".local/share/flatpak/overrides/global".text = ''
        [Context]
        filesystems=/run/current-system/sw/share/X11/fonts:ro;~/.local/share/color-schemes:ro;xdg-config/gtk-3.0:ro;/nix/store:ro;~/.icons:ro'';
    };
    packages = with pkgs; [ nix-your-shell ];
  };

  fonts.fontconfig.enable =
    true; # Allow fonts installed by home-manager to be available session wide

  gtk = {
    enable = true;
    font = {
      name = "Inter";
      size = 10;
    };
    theme = {
      package = pkgs.breeze-gtk;
      name = "Breeze";
    };
    iconTheme = {
      package = pkgs.breeze-icons;
      name = "Breeze";
    };
  };

  services = { kdeconnect.enable = true; };

  xdg = {
    enable = true;
    desktopEntries = {
      steamGamepadUi = { # Menu entry for steam gamepad ui
        terminal = false;
        icon = "steam_deck";
        exec = "steam -gamepadui";
        name = "Steam (Gamepad UI)";
        categories = [ "Game" ];
      };
    };
  };

  programs = {
    password-store = {
      enable = true;
      package = pkgs.pass-wayland;
    };
    bash = {
      enable = true;
      historyFile = "~/.cache/bash_history";
    };
    mangohud = {
      enable = true;
      enableSessionWide = true;
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.obs-vkcapture
        pkgs.obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };
    micro = {
      enable = true;
      settings = {
        clipboard = "terminal";
        mkparents = true;
        scrollbar = true;
        tabstospaces = true;
        tabsize = 4;
        colorscheme = "simple";
        relativeruler = true;
      };
    };
    fish = {
      enable = true;
      interactiveShellInit = "nix-your-shell fish | source";
      loginShellInit = "nix-your-shell fish | source";
      shellAliases = {
        nano = "micro";
        wget = ''wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'';
      };
      functions = {
        fish_greeting = "";
        tsh = "ssh -o RequestTTY=yes $argv tmux -u -CC new -A -s tmux-main";
      };
      shellInit = ''
        set -g -x NNN_OPTS H
        set -g -x FONTCONFIG_FILE ${pkgs.fontconfig.out}/etc/fonts/fonts.conf
      '';
      plugins = [
        {
          name = "bang-bang";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-bang-bang";
            rev = "f969c618301163273d0a03d002614d9a81952c1e";
            sha256 = "sha256-A8ydBX4LORk+nutjHurqNNWFmW6LIiBPQcxS3x4nbeQ=";
          };
        }
        {
          name = "fzf.fish";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "v9.2";
            sha256 = "sha256-XmRGe39O3xXmTvfawwT2mCwLIyXOlQm7f40mH5tzz+s=";
          };
        }
      ];
    };
    btop = {
      enable = true;
      settings = {
        color_theme = "gruvbox_dark.theme";
        theme_background = false;
        proc_sorting = "cpu direct";
        update_ms = 500;
      };
    };
    tmux = {
      enable = true;
      clock24 = true;
      extraConfig = "set -g mouse on";
    };
    git = {
      enable = true;
      diff-so-fancy.enable = true;
    };
  };
}
