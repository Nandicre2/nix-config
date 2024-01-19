# nix-config
My NixOS config (based largely on [Misterio77's config](https://github.com/Misterio77/nix-config))

## Usage

- Run `nix flake update` to update the flake.lock file with latest packages

- Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system configuration.

## Description

That repository is used for my laptop (aphrodite) and my workstation (ephaistos, mainly on windows for the moment).

I use [Home-manager](https://github.com/nix-community/home-manager) installed as [a module](https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module) (so it build with nixos).

## Disko

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake /path/to/config#hostname