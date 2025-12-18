{ self, inputs, ... }: {

  # 定义 nixosConfigurations
  flake.nixosConfigurations = {
    
    xiaomi-notebook = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      # 模块列表变得极其干净
      modules = [
        ../hosts/xiaomi-notebook/configuration.nix
      ];
    };

    link-eq12 = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ../hosts/link-eq12/configuration.nix
      ];
    };
  };
}