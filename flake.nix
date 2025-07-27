# This is a Nix flake for a cross-platform NixOS configuration
# that supports macOS, NixOS, and WSL (Windows Subsystem for Linux).
# It uses Nix-Darwin for macOS, NixOS-WSL for WSL,
# and Home Manager for user-specific configurations across all platforms.
# If you are comfortable with your home directory structure,
# you can copy it to every platform you have.

{
  description = "Cross-Platform NixOS Configuration for MacOS, NixOS & WSL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util.url = "github:hraban/mac-app-util";

    dotemacs = {
      url = "github:Godalin/dotemacs?ref=main_new_faster";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      nixos-wsl,
      home-manager,
      mac-app-util,
      dotemacs,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      userName = "godalin";
      userEmail = "yly1228@foxmail.com";
      hostNameDarwin = "LinyudeMacBook-Air";
      hostNameWSL = "gk-nixos-wsl";
      hostNameLinux = "gk-nixos";
      specialArgs = inputs // {
        inherit
          userName
          userEmail
          hostNameDarwin
          hostNameWSL
          hostNameLinux
          ;
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#LinyudeMacBook-Air
      darwinConfigurations.${hostNameDarwin} = nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userName} = import ./home.nix;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.sharedModules = [
              mac-app-util.homeManagerModules.default
            ];
          }
        ];
      };

      # gk-nixos-wsl
      # # nixos-rebuild switch --flake .#gk-nixos-wsl
      nixosConfigurations.${hostNameWSL} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          ./configuration-wsl.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userName} = import ./home.nix;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };

      # Standalone Home Manager configuration for x86_64 Linux
      # home-manager switch --flake .#fiction
      homeConfigurations.xxtemp.fiction = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          (
            {
              config,
              pkgs,
              dotemacs,
              ...
            }:
            (
              (import ./home.nix {
                config = config;
                pkgs = pkgs;
                dotemacs = dotemacs;
              })
              // {
                home.username = "fiction";
                home.homeDirectory = "/home/fiction";
              }
            )

          )
        ];
        extraSpecialArgs = specialArgs;
      };
    };
}
