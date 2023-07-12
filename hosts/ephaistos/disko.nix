{ disks ? [ "/dev/nvme0n1" ], ... }:
{
    disk.nvme0n1 = {
      device = builtins.elemAt disks 0;
      type = "disk";
      content = {
          format = "gpt";
          type = "table";
          partitions = [
            {
              name = "ESP";
              bootable = true;
              start = "1MiB";
              end = "1GiB";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "butter";
              start = "1GiB";
              end = "100%";
              part-type = "primary";
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
            }
          ];
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
