{ pkgs, ... }:
{
  # 比如配置 Niri 的配置文件
  xdg.configFile."niri/config.kdl".text = ''
    // 这里写你的 KDL 配置内容
    binds {
        "Mod+T" { spawn "alacritty"; }
        "Mod+Q" { close-window; }
    }
  '';
}