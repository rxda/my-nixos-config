{ config, pkgs, ... }:

{
  # --- GNOME 桌面 ---
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  
  
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


  # Enable the GNOME RDP components
  services.gnome.gnome-remote-desktop.enable = true;

  # Ensure the service starts automatically at boot so the settings panel appears
  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ];
  };

  # Open the default RDP port (3389)
  networking.firewall.allowedTCPPorts = [ 3389 ];

  # Disable autologin to avoid session conflicts
  services.displayManager.autoLogin.enable = false;
  services.getty.autologinUser = null;
}