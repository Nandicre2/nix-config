# System configuration for my SFFPC workstation
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  imports = [
    # List of hardware imports, specific to the host
    inputs.nixos-hardware.nixosModules.common-cpu-amd # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/default.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/pstate.nix
    #inputs.nixos-hardware.nixosModules.common-gpu-nvidia # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/amd/default.nix

    ../common
    ../common/ephemeral-root.nix
    ../common/kde.nix
    ../common/nvidia.nix
  ];

  # Add machine name
  networking.hostName = "ephaistos";

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-amd"];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Steam
  programs.steam.enable = true;

  environment.systemPackages = [
    pkgs.jellyfin-media-player
  ];

}
