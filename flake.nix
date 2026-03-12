{
  description = "da's dotfiles — nix-darwin + home-manager + Determinate Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      system = "aarch64-darwin";
      mkDarwin =
        hostname: extraModules:
        inputs.nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs hostname; };
          modules = [
            inputs.determinate.darwinModules.default
            ./hosts/default.nix
            inputs.home-manager.darwinModules.home-manager
            {
              determinateNix.enable = true;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.da = import ./home/default.nix;
            }
          ] ++ extraModules;
        };
    in
    {
      darwinConfigurations."daMacStudio" = mkDarwin "daMacStudio" [ ./hosts/daMacStudio.nix ];
      darwinConfigurations."daMBP" = mkDarwin "daMBP" [ ];
      darwinConfigurations."daMacBook" = mkDarwin "daMacBook" [ ];

      formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
