{
  description = "Nandicre NixOS configuration";

  # To update all inputs: 'nix flake update'
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-manager (https://github.com/nix-community/home-manager)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-hardware (https://github.com/NixOS/nixos-hardware/)
    hardware.url = "github:nixos/nixos-hardware";

    # Manage disks (https://github.com/nix-community/disko)
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # Choose a config and build with 'nixos-rebuild --flake .#your-hostname'
    # Home-manager is built with the system
    nixosConfigurations = {
      # Primary Desktop (SFFPC)
      ephaistos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/ephaistos ];
      };
      # Laptop VivoBook
      aphrodite = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/aphrodite ];
      };
      #TODO Server - Old desktop
      apollon = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/apollon ];
      };
    };
  };
}
