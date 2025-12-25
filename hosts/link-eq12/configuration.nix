{ config, pkgs, inputs, ... }:

{
  
  # 1. N100 建议使用最新内核，对核显支持更好
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 2. 强制使用 modesetting 驱动 (不要用 "intel" legacy 驱动)
  services.xserver.videoDrivers = [ "modesetting" ];

  # 3. 显卡硬件加速配置
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # ！！！关键点！！！
      # N100 必须使用 intel-media-driver (iHD)
      intel-media-driver 
            
      # 这两个是通用的，可以留着
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
  
  # 4. 修复 Intel GPU 在某些电源状态下的屏幕闪烁/光标丢失问题
  boot.kernelParams = [ 
    "i915.enable_psr=0"  # 关闭面板自刷新
    "i915.enable_guc=2"  # 强制开启 GuC (Firmware loading)
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  networking.firewall.checkReversePath = false;


  # --- 引导与内核 ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- 网络标识 ---
  networking.hostName = "link-eq12"; 
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
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
  };
  
  # 系统版本 (千万别删)
  system.stateVersion = "25.11"; 
}
