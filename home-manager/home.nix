# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  # Set your username
  home = {
    username = "nandicre";
    homeDirectory = "/home/nandicre";
  };

  programs = {
    home-manager.enable = true;
    
    git = {
      enable = true;
      userName = "Nandicre2";
      userEmail = "nandicre@protonmail.com";
    };

    gh.enable = true;

    firefox.enable = true;
    
    vscode.enable = true;
    
    mpv.enable = true;

    fish.enable = true; # Need it in home and configuration.nix (https://nixos.wiki/wiki/Fish#Installation)

    mangohud.enable = true;
    mangohud.enableSessionWide = true;
  };
  home.packages = with pkgs; [ freetube steam ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  xdg.userDirs = {
   enable = true;
   createDirectories = true;
  };

  home.persistence."/persist/home" = {
    directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Public"
      "Templates"
      "Videos"
    ];
    allowOther = true;
  };
  home.persistence."/persist/home/apps" = {
    removePrefixDirectory = true;
    directories = [
      "firefox/.cache/mozilla"
      "firefox/.mozilla"
    ];
    files = [
    ];
    allowOther = false;
  };
}
