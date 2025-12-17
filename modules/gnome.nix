{ config, pkgs, ... }:

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
    appindicator          # 托盘图标支持 (AppIndicator and KStatusNotifierItem Support)
    dash-to-dock          # 把底栏变成 Dock
    blur-my-shell         # 让界面有毛玻璃效果
    clipboard-indicator   # 剪贴板历史
    pip-on-top
    # user-themes         # 如果你想换 Shell 主题，需要这个
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false; # 确保没被全局禁用
      
      # 这里必须填 UUID 列表
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "clipboard-indicator@tudmotu.com"
        "pip-on-top@rafostar.github.com"
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