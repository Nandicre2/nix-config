# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Configure nix
  nix = {
    settings = {
      trusted-users = ["root" "@wheel"];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };

    optimise = {
      automatic = true;
      dates = "daily";
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # Add nixpkgs input to NIX_PATH
    # This lets nix2 commands still use <nixpkgs>
    nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];
  };

  # Configure your nixpkgs instance
  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  hardware.enableAllFirmware = lib.mkDefault true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "2G";

  zramSwap.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.mutableUsers = false;
  users.users = {
    nandicre = {
      isNormalUser = true;
      description = "Nandicre";
      home = "/home/nandicre";
      password = "test";
      extraGroups =
        [
          "wheel"
          "video"
          "audio"
        ]
        ++ ifTheyExist [
          "networkmanager" # TODO : check if necessary
        ];
      shell = pkgs.fish;
    };
  };

  # Activate home-manager (https://nix-community.github.io/home-manager/index.html#sec-flakes-nixos-module)
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.nandicre = import ../../home-manager/home.nix;
    extraSpecialArgs = {inherit inputs outputs;};
  };

  programs.fish.enable = true; # Need it in home and configuration.nix (https://nixos.wiki/wiki/Fish#Installation)

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Fix vscode on wayland (https://nixos.wiki/wiki/Visual_Studio_Code#Wayland)
}