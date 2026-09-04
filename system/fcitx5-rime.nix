{ pkgs, lib, ... }:

{
  # !!!安装后不生效的话，删除~/.local/share/fcitx5/rime/build，重新部署rime
  # 1. 开启输入法支持
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # 开启 Wayland 支持（GNOME 默认使用 Wayland）
      waylandFrontend = true;
      # 安装插件
      addons = with pkgs; [
        # rime 主程序
        fcitx5-rime
        # 雾凇拼音词库（nixpkgs unstable/24.11 已收录）
        rime-ice
        # 必要的界面库（解决 GTK/Qt 程序的输入问题）
        fcitx5-gtk
        libsForQt5.fcitx5-qt # 针对 Qt5 程序（WPS 主要用这个）
        kdePackages.fcitx5-qt # 针对 Qt6 程序
      ];
    };
  };

  environment.variables = {
    # 很多 Qt 程序只认 "fcitx"，不认 "fcitx5"
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
    # NIXOS_OZONE_WL = "1";
  };

}
