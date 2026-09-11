{ inputs, self, ... }:
{

  # 定义 nixosConfigurations
  flake.nixosConfigurations = {

    xiaomi-notebook = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs self; };
      modules = [
        ./common.nix
        ../hosts/xiaomi-notebook/configuration.nix
        ../hosts/xiaomi-notebook/hardware-configuration.nix
        inputs.disko.nixosModules.disko
        ../hosts/xiaomi-notebook/disko.nix
      ];
    };

    link-eq12 = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs self; };
      modules = [
        ./common.nix
        ../hosts/link-eq12/configuration.nix
        ../hosts/link-eq12/hardware-configuration.nix
        ../system/disable-hibernate.nix
        inputs.disko.nixosModules.disko
        ../hosts/link-eq12/disko.nix
      ];
    };
  };

  # 保留独立的 Home Manager 配置，便于需要时单独更新用户环境。
  flake.homeConfigurations.rxda = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [ inputs.nix-vscode-extensions.overlays.default ];
    };

    extraSpecialArgs = { inherit inputs; };
    modules = [
      ../modules/home.nix
    ];
  };
}
