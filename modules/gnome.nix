{ pkgs, lib, ... }:

let
  # 1. 定义壁纸在 Nix Store 中的路径
  wallpaperFile = pkgs.fetchurl {
    url = "https://140100000.xyz/wallpaper/fox.jpg"; # 或者 user-images 的地址
    sha256 = "sha256-7agK/PfIivK1zq7kVozI4llVO22xqned1rOzFsqHAdk=";
  };
in
{

  gtk = {
    enable = true;

    # 1. 设置图标主题
    iconTheme = {
      name = "Adwaita"; # 或者你刚才在 Tweaks 里选的名字，比如 "Papirus"
      package = pkgs.adwaita-icon-theme; # 对应的包
    };

    # 2. 设置鼠标主题
    cursorTheme = {
      name = "Adwaita"; # 或者 "Vanilla-DMZ" 等
      package = pkgs.adwaita-icon-theme;
    };

    # 3. 设置界面 GTK 主题 (可选)
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
  };

  home.packages = with pkgs.gnomeExtensions; [
    # 举例：常用的几个扩展
    appindicator # 托盘图标支持 (AppIndicator and KStatusNotifierItem Support)
    dash-to-dock # 把底栏变成 Dock
    blur-my-shell # 让界面有毛玻璃效果
    clipboard-indicator # 剪贴板历史
    pip-on-top
    user-themes # 如果你想换 Shell 主题，需要这个
  ];

  dconf.settings = {
    "org/gnome/desktop/background" = {
      # GNOME 要求路径必须以 file:// 开头
      picture-uri = lib.mkForce "file://${wallpaperFile}";
      picture-uri-dark = lib.mkForce "file://${wallpaperFile}"; # 也要设置暗色模式下的壁纸
      picture-options = "zoom"; # 填充模式
    };

    # 顺便设置锁屏壁纸
    "org/gnome/desktop/screensaver" = {
      picture-uri = lib.mkForce "file://${wallpaperFile}";
    };

    "org/gnome/desktop/wm/keybindings" = {
      # 禁用“切换应用程序” (原本的 Alt+Tab)
      switch-applications = [ ];
      # 禁用“反向切换应用程序” (原本的 Alt+Shift+Tab)
      switch-applications-backward = [ ];

      # 将 Alt+Tab 绑定到“切换窗口”
      switch-windows = [ "<Alt>Tab" ];
      # 将 Alt+Shift+Tab 绑定到“反向切换窗口”
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    # 1. 注册自定义快捷键的目录
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings =[
        # 注意：这里的路径必须以斜杠 "/" 结尾！
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        # 如果有第二个快捷键，继续添加 "/.../custom1/"
      ];
    };

    # 2. 定义 custom0 快捷键的具体内容
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Snipaste Capture";   # 快捷键名称（在系统设置里显示的名称）
      command = "snipaste snip";   # 触发的命令
      binding = "<Alt>a";          # 绑定的按键
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      # true: 在全屏模式下启用（全屏看视频或玩游戏时，鼠标贴边可以呼出 Dock）
      # false: 在全屏模式下完全禁用（鼠标贴边也不会呼出，防误触）
      autohide-in-fullscreen = true; 
      
      # [可选] 下面是一些常用的其他 Dash to Dock 选项，你可以顺便一起用代码配置
      
      dock-fixed = false;       # 取消一直固定在桌面上（启用自动隐藏的前提）
      intellihide = true;       # 开启智能隐藏
      dock-position = "BOTTOM"; # Dock 放在底部 ("BOTTOM", "LEFT", "RIGHT", "TOP")
      # dash-max-icon-size = 48;  # 图标大小
      # apply-custom-theme = true;# 使用内置主题（有时候比系统自带的顺眼）
    };

    "org/gnome/shell" = {
      disable-user-extensions = false; # 确保没被全局禁用

      enabled-extensions = with pkgs.gnomeExtensions; [
        # --- 第三方热门插件 (使用 pkgs.gnomeExtensions) ---
        dash-to-dock.extensionUuid
        appindicator.extensionUuid
        blur-my-shell.extensionUuid
        clipboard-indicator.extensionUuid
        pip-on-top.extensionUuid

        # --- GNOME 官方内置扩展 (通常由 gnome-shell-extensions 包提供) ---
        # 注意：官方扩展在 Nixpkgs 中通常是一组，UUID 比较固定，可以直接写字符串
        # 或者使用 pkgs.gnome-shell-extensions 里面的内置属性（如果存在）
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "light-style@gnome-shell-extensions.gcampax.github.com"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "status-icons@gnome-shell-extensions.gcampax.github.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
    };
  };


}
