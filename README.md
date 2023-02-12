# nix-config
My NixOS config (based largely on [Misterio77's config](https://github.com/Misterio77/nix-config))

## Usage

- Run `nix flake update` to update the flake.lock file with latest
  packages
- Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system
  configuration.
- Run `home-manager switch --flake .#username@hostname` to apply your home
  configuration.

And that's it, really! You're ready to have fun with your configurations using
the latest and greatest nix3 flake-enabled command UX.
