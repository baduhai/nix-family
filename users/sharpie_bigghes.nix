{ config, pkgs, ... }:

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
    sessionVariables = {
      EDITOR = "micro";
    };
    file = {
      # Dotfiles that can't be managed via home-manager
      ".scripts/pfetch" = {
        executable = true;
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/baduhai/dotfiles/master/scripts/pfetch";
          sha256 = "UEfTG1XCuN2GlpPz1gdQ5mxgutlX2XL58rGOqtaUgV4=";
        };
      };
      ".local/share/color-schemes/BreezeDarkNeutral.colors".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/baduhai/dotfiles/master/color-schemes/BreezeDarkNeutral.colors";
        sha256 = "Fw5knhpV47HlgYvbHFzfi6M6Tk2DTlAuFUYc2WDDBc8=";
      };
      ".config/MangoHud/MangoHud.conf".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/baduhai/dotfiles/master/MangoHud/MangoHud.conf";
        sha256 = "WCRsS6njtU4aR7tMiX8oWa2itJyy04Zp7wfwV20SLZs=";
      };
      # Autostart programs
      # Fix flatpak fonts, themes, icons and cursor
      ".icons/breeze_cursors".source = config.lib.file.mkOutOfStoreSymlink "/run/current-system/sw/share/icons/breeze_cursors";
      ".local/share/flatpak/overrides/global".text = "[Context]\nfilesystems=/run/current-system/sw/share/X11/fonts:ro;~/.local/share/color-schemes:ro;xdg-config/gtk-3.0:ro;/nix/store:ro;~/.icons:ro";
    };
  };

  fonts.fontconfig.enable = true; # Allow fonts installed by home-manager to be available session wide

  gtk = {
    enable = true;
    font = { name = "Inter"; size = 10; };
    theme = { package = pkgs.breeze-gtk; name = "Breeze"; };
    iconTheme = { package = pkgs.breeze-icons; name = "Breeze"; };
  };

  services = {
    kdeconnect.enable = true;
  };

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
    home-manager.enable = true;
    password-store = {
      enable = true;
      package = pkgs.pass-wayland;
    };
    bash = {
      enable = true;
      historyFile = "~/.cache/bash_history";
    };
    micro = {
      enable = true;
      settings = {
        clipboard = "terminal";
        mkparents = true;
        scrollbar = true;
        tabstospaces = true;
        tabsize = 2;
      };
    };
    fish = {
      enable = true;
      interactiveShellInit = "any-nix-shell fish --info-right | source";
      loginShellInit = "any-nix-shell fish --info-right | source";
      shellAliases = {
        d = "kitty +kitten diff";
        nano = "micro";
        wget = "wget --hsts-file=\"$XDG_DATA_HOME/wget-hsts\"";
        ssh = "kitty +kitten ssh";
      };
      functions = {
        fish_greeting = ''
          set -x PF_INFO ascii title os kernel uptime wm memory palette
          eval $HOME/.scripts/pfetch
        '';
        pacin = "nix-env -iA nixos.$argv";
        pacre = "nix-env -e $argv";
      };
      shellInit = ''
        set -g PF_INFO ascii title os kernel uptime wm memory palette
        set -g theme_date_format "+%H:%M"
        set -g theme_date_timezone Europe/Berlin
        set -g theme_avoid_ambiguous_glyphs yes
        set -g theme_color_scheme dark
        set -g theme_nerd_fonts yes
        set -g theme_display_git_default_branch yes
        set -g -x FONTCONFIG_FILE ${pkgs.fontconfig.out}/etc/fonts/fonts.conf
      '';
      plugins  = [
        {
          name = "bobthefish";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "theme-bobthefish";
            rev = "2dcfcab653ae69ae95ab57217fe64c97ae05d8de";
            sha256 = "jBbm0wTNZ7jSoGFxRkTz96QHpc5ViAw9RGsRBkCQEIU=";
          };
        }
        {
          name = "bang-bang";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-bang-bang";
            rev = "f969c618301163273d0a03d002614d9a81952c1e";
            sha256 = "A8ydBX4LORk+nutjHurqNNWFmW6LIiBPQcxS3x4nbeQ=";
          };
        }
        {
          name = "fzf.fish";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "v9.2";
            sha256 = "XmRGe39O3xXmTvfawwT2mCwLIyXOlQm7f40mH5tzz+s=";
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
    mangohud = {
      enable            = true;
      enableSessionWide = true;
    };
  };
}
