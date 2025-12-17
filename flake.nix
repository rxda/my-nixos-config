{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixos-hardware.url="github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-vscode-extensions, ... }: {
    nixosConfigurations = {
      # 这里的 my-nixos 替换成你的主机名称
      xiaomi-notebook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/xiaomi-notebook/configuration.nix
          # ./niri.nix
          # 将 home-manager 配置为 nixos 的一个 module
          # 这样在 nixos-rebuild switch 时，home-manager 配置也会被自动部署
          ({ pkgs, ... }: {
            # vscode 扩展overlays
          nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
          })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            

            home-manager.users.rxda = {
              imports = [
                ./modules/home.nix
              ];
            };
          }
        ];
      };

      link-eq12 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/link-eq12/configuration.nix
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-intel
          ({ pkgs, ... }: {
          nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
          })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            

            home-manager.users.rxda = {
              imports = [
                ./modules/home.nix
              ];
            };
          }
        ];
      };
    };
  };
}
