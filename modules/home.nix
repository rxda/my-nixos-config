{ config, pkgs, ... }:

{
  # 引入拆分后的模块
  imports = [
    ./modules/shell.nix
    ./modules/git.nix
    ./modules/vscode.nix
    ./modules/packages.nix
    ./modules/rust.nix
  ];

  # 用户基础信息
  home.username = "rxda";
  home.homeDirectory = "/home/rxda";

  # Home Manager 版本控制
  home.stateVersion = "24.11";

  # 启用 Home Manager 自身管理
  programs.home-manager.enable = true;
}