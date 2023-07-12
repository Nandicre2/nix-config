{ disks ? [ "/dev/nvme0n1" ], ... }:
{
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
                  "/nix" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/etc" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/home" = {
                    mountOptions = [ "compress=zstd" ];
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
}
