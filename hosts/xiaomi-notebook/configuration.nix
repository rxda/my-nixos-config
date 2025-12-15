{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      
      # 引入拆分后的系统模块
      ../../system/nvidia.nix
      ../../system/desktop.nix
      ../../system/virtualization.nix
      ../../system/services.nix
      ../../system/variables.nix
    ];

  # --- 引导与内核 ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- 网络标识 ---
  networking.hostName = "rxda-xiaomi-notebook"; 
  networking.networkmanager.enable = true;

  # --- 时区与语言 ---
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # --- 用户配置 ---
  users.users.rxda = {
    isNormalUser = true;
    description = "rxda";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
  };
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # --- Nix 核心设置 ---
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # 系统版本 (千万别删)
  system.stateVersion = "24.11"; 
}