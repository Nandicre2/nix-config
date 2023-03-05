# This file (and the global directory) holds config that i use on all hosts
{ lib, inputs, outputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    ./nix.nix
    ./docker.nix
  ];

  home-manager = {
    users.nandicre = import ../../home-manager/home.nix;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  programs.fuse.userAllowOther = true;
  hardware.enableRedistributableFirmware = true;
}