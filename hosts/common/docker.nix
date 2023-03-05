{ pkgs , ... }:
{
  virtualisation.docker = {
    enable = true;
    # Whether to periodically prune Docker resources
    autoPrune.enable = true;
  };

#  environment.persistence = {
#    "/persist".directories = [
#      "/var/lib/containers"
#    ];
#  };
}