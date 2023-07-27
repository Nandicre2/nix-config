# This file (and the global directory) holds config that i use on all hosts
{ inputs, outputs, pkgs, lib, config, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Add nixpkgs input to NIX_PATH
    # This lets nix2 commands still use <nixpkgs>
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.nandicre = import ../../home-manager/home.nix;
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
