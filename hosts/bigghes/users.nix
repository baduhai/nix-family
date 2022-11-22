{ config, pkgs, ... }:
{
  environment.sessionVariables = rec {
    KDEHOME = "$XDG_CONFIG_HOME/kde4"; # Stops kde from placing a .kde4 folder in the home dir
  };

  users.users.sharpie = {
    isNormalUser = true;
    description = "Gabriel";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    hashedPassword = "$6$c8/6SMBcsDP1Rht4$s7wsVJRKCsuQhtkG6kQzu/HMtW.fBItcZwL5/5w2D8RgBrIN4HGR0IT.AXtSSoTU.kjfeeBAOBm2GEB2ijciP0";
  };
}
