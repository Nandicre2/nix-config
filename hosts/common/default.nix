# This file (and the global directory) holds config that i use on all hosts
{ inputs, outputs, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./nix.nix
    ./podman.nix
  ];

  home-manager = {
    users.nandicre = import ../../home-manager/home.nix;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  programs.fuse.userAllowOther = true;
  hardware.enableRedistributableFirmware = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  zramSwap.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
