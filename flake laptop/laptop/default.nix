{ config, pkgs, lib, ... }:

{
  imports = [
    ../../hardware/laptop
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "laptop";

  users.users.danny = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "uwsm start default";
        user = "danny";
      };
    };
  };

  services.tailscale = {
    enable = true;
  };

  # ThinkPad W540 extras
  services.tlp.enable = true;        # battery / power management
  services.thinkfan.enable = true;   # fan control
  services.fprintd.enable = true;    # fingerprint reader

  programs.fish.enable = true;
  security.sudo.extraRules = [{
    users = [ "danny" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];
  users.users.danny.shell = pkgs.fish;

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      XKB_DEFAULT_LAYOUT = "uk";
      # AMD_VULKAN_ICD removed — W540 uses Intel/NVIDIA, not AMD
    };
    # Required for nix-flatpak to work. Not in home-manager because of gmodena/nix-flatpak#33.
    systemPackages = [ pkgs.flatpak ];
  };

  # Needs to be here in combination with home-manager to create the file to launch it with UWSM.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 3;

  # Do not change this!
  system.stateVersion = "25.11";
}
