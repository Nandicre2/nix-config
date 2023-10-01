# System configuration for my laptop Vivobook
{
  inputs,
  lib,
  ...
}: {
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  imports = [

    # List of hardware imports, specific to the host
    inputs.hardware.nixosModules.common-cpu-amd # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/default.nix
    inputs.hardware.nixosModules.common-cpu-amd-pstate # https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/pstate.nix
    inputs.hardware.nixosModules.common-gpu-amd # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/amd/default.nix
    inputs.hardware.nixosModules.common-pc-laptop # https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/default.nix
    inputs.hardware.nixosModules.common-pc-laptop-acpi_call # https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/acpi_call.nix
    inputs.hardware.nixosModules.common-pc-laptop-ssd # https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/ssd

    ../common

    inputs.disko.nixosModules.disko
  ];

  # Add machine name
  networking.hostName = "aphrodite";

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-amd"];
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  disko.devices = {
    disk.main = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02"; # for grub MBR
          };
          ESP = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          persistence = {
            name = "persistence";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          nix = {
            size = "100G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = [
                "defaults"
                "noatime"
              ];
            };
          };
          persist = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/persist";
              mountOptions = [
                "defaults"
                "noatime"
              ];
            };
          };
        };
      };
    };
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=128M" "mode=755"];
  };
  fileSystems."/home" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=128M" "mode=0755"];
    neededForBoot = true;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
