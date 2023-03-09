{ pkgs , ... }:
{
  virtualisation.podman = {
    enable = true;
    # Whether to periodically prune Docker resources
    autoPrune.enable = true;
    # Create an alias mapping docker to podman.
    dockerCompat = true;
  };

#  environment.persistence = {
#    "/persist".directories = [
#      "/var/lib/containers"
#    ];
#  };
}