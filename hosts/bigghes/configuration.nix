{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./packages.nix
      ./users.nix
    ];

  boot = {
    plymouth.enable = true;
#     initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
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
      LC_TIME = "pt_BR.utf8";
    };
  };

  services = {
    printing.enable = true;
    fwupd.enable = true; # Firmware upgrade service
    openssh.enable = true;
    tailscale.enable = true;
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
      excludePackages = ( with pkgs; [ xterm ]);
      desktopManager.plasma5 = {
        enable     = true;
        excludePackages = ( with pkgs.plasma5Packages; [ elisa oxygen khelpcenter ]);
      };
      displayManager = {
        defaultSession = "plasmawayland";
        sddm = {
          enable = true;
          autoNumlock = true;
          settings = {
            Theme = {
              CursorTheme = "breeze_cursors";
            };
            X11 = {
              UserAuthFile = ".local/share/sddm/Xauthority";
            };
          };
        };
      };
    };
  };

  security.rtkit.enable = true; # Needed for pipewire to acquire realtime priority

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    gc = { # Garbage collector
      automatic = true;
      options = "--delete-older-than 8d";
    };
  };

  system.stateVersion = "22.05";

}
