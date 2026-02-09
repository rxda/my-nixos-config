{ inputs, self, ... }: {

  # 定义 nixosConfigurations
  flake.nixosConfigurations = {

    xiaomi-notebook = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs self; };
      # 模块列表变得极其干净
      modules = [
        ./common.nix
        ../hosts/xiaomi-notebook/configuration.nix
        ../hosts/xiaomi-notebook/hardware-configuration.nix
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
}
