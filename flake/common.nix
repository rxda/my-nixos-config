# flake/common.nix
{ inputs, ... }: {
  # 这个文件会被所有主机导入
  imports = [
    # 1. 引入 Agenix 和 VSCode Server
    inputs.agenix.nixosModules.default

    # 2. 引入 Home Manager 的通用配置
    inputs.home-manager.nixosModules.home-manager
    {
      # 这部分是两台机器完全一样的
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = { inherit inputs; }; 

      home-manager.users.rxda = {
        imports = [
          ../modules/home.nix
        ];
      };
    }
  ];

  # 3. 引入 VSCode 扩展的 overlay
  nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];
}