# System configuration for my laptop Vivobook
{
  inputs,
  lib,
  pkgs,
  ...
}: {
  system.stateVersion = "23.05"; # Don't change this (https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion)

  imports = [
    # List of hardware imports, specific to the host
    inputs.nixos-hardware.nixosModules.common-cpu-amd # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/default.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/pstate.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower #https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/zenpower.nix
    inputs.nixos-hardware.nixosModules.common-gpu-amd # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/amd/default.nix
    inputs.nixos-hardware.nixosModules.common-pc-laptop # https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/default.nix
    inputs.nixos-hardware.nixosModules.common-pc-laptop-acpi_call # https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/acpi_call.nix
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd # https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/ssd

    ../common
    ../common/ephemeral-root.nix
    ../common/kde.nix
  ];

  # Add machine name
  networking.hostName = "aphrodite";

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-amd"];
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

   environment.systemPackages = [
    pkgs.jellyfin-media-player
  ];
}
