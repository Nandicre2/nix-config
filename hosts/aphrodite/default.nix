# System configuration for my laptop Vivobook
{ inputs, config, ... }:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/default.nix
    inputs.hardware.nixosModules.common-cpu-amd-pstate # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/pstate.nix

    inputs.hardware.nixosModules.common-gpu-amd # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/amd/default.nix

    inputs.hardware.nixosModules.common-pc-laptop # https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/default.nix
    inputs.hardware.nixosModules.common-pc-laptop-acpi_call # https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/acpi_call.nix
    inputs.hardware.nixosModules.common-pc-laptop-ssd # https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/ssd

    ./hardware-configuration.nix

    ../common
  ];

  # Add machine name
  networking.hostName = "aphrodite";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
