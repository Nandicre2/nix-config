# This file defines overlays
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    podman-compose = prev.podman-compose.overrideAttrs(oldAttrs: {
      version = "1.0.4-dev";
      src = final.fetchFromGitHub {
        repo = "podman-compose";
        owner = "containers";
        rev = "08ffcf6126a3ae4016e3d81e963a3629e4b75986";
        sha256 = "sha256-ybdwBc//clXQ8WHG3lfGP4g8VLECFvEWSnVxZxjhLLU=";
      };
    });
  };
}
