{ self, inputs, ... }: {

  # 定义 nixosConfigurations
  flake.nixosConfigurations = {
    
    xiaomi-notebook = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      # 模块列表变得极其干净
      modules = [
        ./common.nix
        ../hosts/xiaomi-notebook/configuration.nix
        ../hosts/xiaomi-notebook/hardware-configuration.nix
        ../system/nvidia.nix
        ../system/desktop.nix
        ../system/virtualization.nix
        ../system/services.nix
        ../system/variables.nix
        ../system/singbox.nix
      ];
    };

    link-eq12 = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./common.nix
        ../hosts/link-eq12/configuration.nix
        ../hosts/link-eq12/hardware-configuration.nix
        ../system/desktop.nix
        ../system/virtualization.nix
        ../system/services.nix
        ../system/variables.nix
        ../system/singbox.nix
      ];
    };
  };
}