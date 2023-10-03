{
  description = "Nandicre NixOS configuration";

  # To update all inputs: 'nix flake update'
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixOS-hardware (https://github.com/NixOS/nixos-hardware/)
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Manage disks (https://github.com/nix-community/disko)
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence (https://github.com/nix-community/impermanence)
    impermanence.url = "github:nix-community/impermanence";

    # Home-manager (https://github.com/nix-community/home-manager)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Manage secrets (https://github.com/Mic92/sops-nix)
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    impermanence,
    home-manager,
    sops-nix,
    ...
  } @ inputs: {
    # Choose a config and build with 'nixos-rebuild --flake .#your-hostname'
    # Home-manager is built with the system
    nixosConfigurations = {
      # Primary Desktop (SFFPC)
      ephaistos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [./hosts/ephaistos];
      };
      # Laptop VivoBook
      aphrodite = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/aphrodite
          impermanence.nixosModules.impermanence          
        ];
      };
      #TODO Server - Old desktop
      apollon = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [./hosts/apollon];
      };
    };
  };
}
