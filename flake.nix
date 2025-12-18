# flake.nix (新版本)
{
  description = "rxda's NixOS configurations";

  inputs = {
    # --- 你的 Inputs 保持不变 ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    agenix.url = "github:ryantm/agenix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    daeuniverse.url = "github:daeuniverse/flake.nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
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