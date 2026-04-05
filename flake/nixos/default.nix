{
  inputs,
  self,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs self;
  };
  modules = [
    ../../hosts/nixos
    inputs.home-manager.nixosModules.home-manager
    inputs.flatpak.nixosModules.nix-flatpak
    {
      home-manager = {
        users.danny = ../../homes/nixos;
        extraSpecialArgs = {
          inherit inputs self;
        };
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }
    {
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia.open = true;
    }
  ];
}
