{ config, pkgs, ... }:

{
  # --- GNOME 桌面 ---
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  
  # 排除不需要的 GNOME 预装软件
  environment.gnome.excludePackages = with pkgs; [];
  
  # GNOME Keyring (密码环)
  services.gnome.gnome-keyring.enable = true;
  services.gnome.core-apps.enable = true;

  # 键盘布局
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # --- 音频 (Pipewire) ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- 打印 ---
  services.printing.enable = true;

  # --- 输入法 (IBus) ---
  # 建议：既然你在折腾 Linux，将来可以考虑换 Fcitx5，比 IBus 好用
  i18n.inputMethod = {
    type = "ibus";
    enable = true;
    ibus.engines = with pkgs.ibus-engines; [
      libpinyin
      rime
    ];
  };

  # --- 字体 ---
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      source-code-pro
      hack-font
      jetbrains-mono
      wqy_microhei
      wqy_zenhei
      nerd-fonts.fira-code 
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "FiraCode Nerd Font Mono" "Noto Sans Mono CJK SC" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}