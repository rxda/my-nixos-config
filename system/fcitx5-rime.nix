{ pkgs, lib, ... }:

{
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
        libsForQt5.fcitx5-qt  # 针对 Qt5 程序（WPS 主要用这个）
        kdePackages.fcitx5-qt # 针对 Qt6 程序
      ];
    };
  };

  environment.variables = {
    # 很多 Qt 程序只认 "fcitx"，不认 "fcitx5"
    QT_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
    NIXOS_OZONE_WL = "1";
  };

  # 2. (可选) 针对 GNOME 的额外优化
  # Fcitx5 在 GNOME Wayland 下可能没有状态栏图标
  # 建议安装 GNOME 扩展: "AppIndicator and KStatusNotifierItem Support" 
  # 或者 "Input Method Panel"
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.kimpanel
  ];

  # --- 2. 用户级配置 (Home Manager Level) ---
  home-manager.users.rxda = {
    # 自动链接雾凇拼音的所有配置文件到 Rime 目录
    # 这样你就不用手动下载、解压和更新词库了
    home.file.".local/share/fcitx5/rime" = {
      source = "${pkgs.rime-ice}/share/rime-data";
      recursive = true;
    };

    # 写入 Rime 的自定义配置，指定启用雾凇拼音
    home.file.".local/share/fcitx5/rime/default.custom.yaml".text = ''
      patch:
        schema_list:
          - schema: double_pinyin_flypy
          - schema: rime_ice
        
        menu/page_size: 5
    '';

    dconf.settings."org/gnome/shell" = {
      # 使用 mkAfter 将这两个 UUID 追加入到列表中
      enabled-extensions = lib.mkAfter [
        pkgs.gnomeExtensions.appindicator.extensionUuid
        pkgs.gnomeExtensions.kimpanel.extensionUuid
      ];
    };

    # (可选) 如果你想给 Fcitx5 换个皮肤 (比如简约白)
    # home.file.".local/share/fcitx5/themes/".source = ...
  };

}