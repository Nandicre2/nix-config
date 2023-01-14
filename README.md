# nix-config
My NixOS config

## Usage

- Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system
  configuration.
- Run `home-manager switch --flake .#username@hostname` to apply your home
  configuration.

And that's it, really! You're ready to have fun with your configurations using
the latest and greatest nix3 flake-enabled command UX.
