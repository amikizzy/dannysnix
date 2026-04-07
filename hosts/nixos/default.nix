{ config, pkgs, lib, ... }:

{
  imports = [
    ../../hardware/nixos
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos";

  users.users.danny = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio"];
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
    # Enable tailscale at startup
    
  };

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
      AMD_VULKAN_ICD = "RADV";
      XKB_DEFAULT_LAYOUT = "uk";
    };
    # Required for nix-flatpak to work. Not in home-manager because of gmodena/nix-flatpak#33.
    systemPackages = [pkgs.flatpak];
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
        # Permit the installation of
        # packages with unfree licences.
        allowUnfree = true;
      };
};
	
  boot.loader.systemd-boot.enable = true;
  # Pressing ESC on boot will bring up the bootloader menu.
  boot.loader.timeout = 3;

  # Do not change this!
  system.stateVersion = "25.11";
}
