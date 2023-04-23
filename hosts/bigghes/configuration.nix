{ inputs, config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    plymouth.enable = true;
    # initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      timeout = 1;
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    kernel.sysctl = { "net.ipv4.tcp_mtu_probing" = 1; };
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "udev.log_priority=3"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=false"
    ];
  };

  networking = {
    hostName = "bigghes";
    firewall.enable = false;
    networkmanager.enable = true;
  };

  sound.enable = true;
  hardware = {
    bluetooth.enable = true;
    xpadneo.enable = true;
    opengl.driSupport32Bit = true; # For OpenGL games
    steam-hardware.enable = true; # Allow steam client to manage controllers
    pulseaudio.enable = false; # Use pipewire instead
  };

  time.timeZone = "America/Bahia";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.utf8";
      LC_IDENTIFICATION = "pt_BR.utf8";
      LC_MEASUREMENT = "pt_BR.utf8";
      LC_MONETARY = "pt_BR.utf8";
      LC_NAME = "pt_BR.utf8";
      LC_NUMERIC = "pt_BR.utf8";
      LC_PAPER = "pt_BR.utf8";
      LC_TELEPHONE = "pt_BR.utf8";
      LC_TIME = "en_IE.utf8";
    };
  };

  services = {
    printing.enable = true;
    fwupd.enable = true;
    fstrim.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    flatpak.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "altgr-intl";
      excludePackages = (with pkgs; [ xterm ]);
      desktopManager.plasma5.enable = true;
      displayManager = {
        defaultSession = "plasmawayland";
        sddm = {
          enable = true;
          autoNumlock = true;
          settings = {
            Theme = { CursorTheme = "breeze_cursors"; };
            X11 = { UserAuthFile = ".local/share/sddm/Xauthority"; };
          };
        };
      };
    };
  };

  security.rtkit.enable =
    true; # Needed for pipewire to acquire realtime priority

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    gc = { # Garbage collector
      automatic = true;
      options = "--delete-older-than 8d";
    };
    settings = {
      auto-optimise-store = true;
      connect-timeout = 10;
      log-lines = 25;
      min-free = 128000000;
      max-free = 1000000000;
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "/nix/var/nix/profiles/per-user/root/channels"
      "nixos-config=${./configuration.nix}"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true; # Allow non open source packages
  };

  environment = {
    systemPackages = with pkgs; [
      ark
      aspell
      aspellDicts.de
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.pt_BR
      bat
      bind
      discover
      fd
      filelight
      firefox-wayland # Until firefox moves to using wayland by default
      fzf
      git
      kate
      kolourpaint
      libreoffice-qt
      mangohud
      micro
      neofetch
      steam-run
      tmux
      tree
      unrar
      wget
    ];
    sessionVariables = rec {
      KDEHOME =
        "$XDG_CONFIG_HOME/kde4"; # Stops kde from placing a .kde4 folder in the home dir
      NIXOS_OZONE_WL = "1";
    };
    plasma5.excludePackages =
      (with pkgs.plasma5Packages; [ elisa oxygen khelpcenter ]);
    etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;
  };

  programs = {
    steam.enable = true;
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

  users.users = {
    sharpie = {
      isNormalUser = true;
      description = "Gabriel";
      shell = pkgs.fish;
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcwF1yuWEfYGScNocEbs0AmGxyTIzGc4/IhpU587SJE"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL"
      ];
      hashedPassword =
        "$6$c8/6SMBcsDP1Rht4$s7wsVJRKCsuQhtkG6kQzu/HMtW.fBItcZwL5/5w2D8RgBrIN4HGR0IT.AXtSSoTU.kjfeeBAOBm2GEB2ijciP0";
    };
    root = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcwF1yuWEfYGScNocEbs0AmGxyTIzGc4/IhpU587SJE"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL"
      ];
      hashedPassword = "!";
    };
  };

  system.stateVersion = "22.05";

}
