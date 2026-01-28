# flake.nix (新版本)
{
  description = "rxda's NixOS configurations";

  inputs = {
    # 1. 主 Nixpkgs 源
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # 2. 让 home-manager 跟随主 nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 3. 其他工具也全部跟随主 nixpkgs
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-templates = {
      url = "github:rxda/my-nix-templates";
    };
  };

  # outputs 不再需要手写参数
  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit self inputs; } {

      # 定义支持的系统架构
      systems = [ "x86_64-linux" ];

      # 告诉 flake-parts 去哪里找你的配置碎片
      # 它会自动导入 ./flake 目录下的 default.nix 或 flake.nix
      imports = [
        ./flake
      ];
    };
}
