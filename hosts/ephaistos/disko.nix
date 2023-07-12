{ disks ? [ "/dev/nvme0n1" ], ... }: {
  disko.devices = {
    disk.main = {
      device = builtins.elemAt disks 0;
      type = "disk";
      content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1MiB";
              end = "1GiB";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  # Mountpoints inferred from subvolume name
                  "/persist" = {
                    mountOptions = [ "compress=zstd" ];
                  };
                  "/nix" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "mode=755"
      ];
    };
  };
}