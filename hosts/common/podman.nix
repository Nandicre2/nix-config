{ pkgs , ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

#  environment.persistence = {
#    "/persist".directories = [
#      "/var/lib/containers"
#    ];
#  };
}