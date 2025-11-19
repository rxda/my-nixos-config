# /etc/nixos/niri.nix
{ config, pkgs, lib, ... }:

{
  # 1. 启用 Niri
  programs.niri.enable = true;

  # 2. 这里定义 Niri 专属的软件包
  # NixOS 会自动把这里的列表和 configuration.nix 里的列表合并
  environment.systemPackages = with pkgs; [
    # 必装三件套
    alacritty     # 终端 (Niri 默认配置通常用这个)
    fuzzel        # 启动器
    waybar        # 状态栏

    # 辅助工具
    swaybg        # 设置壁纸 (Niri 需要外部工具设壁纸)
    swaylock      # 锁屏
    mako          # 通知
    wl-clipboard  # 剪贴板
    grim          # 截图
    slurp         # 截图选区
    
    # 音量/亮度调节工具
    pamixer
    brightnessctl
  ];

  # 3. 可以顺便把 Niri 需要的环境变量也写在这里
  environment.variables = {
    # 强制 Electron 应用 (如 VSCode, Discord) 使用 Wayland，否则会模糊
    NIXOS_OZONE_WL = "1"; 
  };
  
  # 4. 如果你需要 xdg-portal (用于屏幕共享等)，通常 programs.niri 会自动处理，
  # 但如果你想明确指定或添加额外的，也可以写在这里。
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}