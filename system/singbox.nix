{ config, pkgs, inputs, ... }:

let
  # 这里的 pkgs.system 会自动匹配当前机器架构 (x86_64-linux)
  # 直接拿到你那个仓库输出的 default 包
  sing-box-latest = inputs.sing-box-unstable.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{


  # 1. 确保安装 sing-box
  environment.systemPackages = [ sing-box-latest ];

  age.secrets.singbox-url = {
    file = ../secrets/singbox-url.age;
    owner = "root"; # 因为是 systemd (root) 要读它
    mode = "400";
  };

  # 2. 定义 sing-box 主服务
  systemd.services.sing-box = {
    description = "Sing-box Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      # 指定配置文件路径 (这个路径是可写的)
      ExecStart = "${sing-box-latest}/bin/sing-box run -c /var/lib/sing-box/config.json";
      Restart = "always";

      # 创建状态目录 /var/lib/sing-box
      StateDirectory = "sing-box";
      WorkingDirectory = "/var/lib/sing-box";

      # --- 权限设置 (TUN 模式必备) ---
      # 如果你用 Tun 模式，通常需要 root 或 NET_ADMIN 权限
      User = "root";
      # 如果你很在意安全，想用非 root 用户，必须开启以下 Capability：
      # User = "sing-box";
      # DynamicUser = true;
      # CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
      # AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
    };
  };

  # 3. 定义更新脚本 (一次性服务)
  systemd.services.sing-box-update = {
    description = "Update sing-box configuration";
    serviceConfig = {
      Type = "oneshot";
      User = "root"; # 必须是 root 才有权限写文件并重启服务
    };
    script = ''
      # === 配置你的订阅链接 ===
      # 建议在链接最后加上 &flag=sing-box 让转换后端吐出正确的格式
      URL=$(cat ${config.age.secrets.singbox-url.path})
      
      CONFIG_DIR="/var/lib/sing-box"
      TARGET="$CONFIG_DIR/config.json"
      TEMP="$CONFIG_DIR/config.json.tmp"
      
      mkdir -p "$CONFIG_DIR"

      echo "Downloading update..."
      ${pkgs.curl}/bin/curl -L -o "$TEMP" "$URL"
      
      # === 关键步骤：验证配置 ===
      # 下载下来的文件可能是坏的 (比如网络中断，或者机场后端崩了)
      # 如果直接覆盖，sing-box 就会挂掉。
      # 所以必须先用 sing-box check 检查一遍语法。
      
      if ${sing-box-latest}/bin/sing-box check -c "$TEMP"; then
        echo "Configuration check passed. Restarting service..."
        mv "$TEMP" "$TARGET"
        ${pkgs.systemd}/bin/systemctl restart sing-box
      else
        echo "FATAL: Downloaded config is invalid! Keeping the old one."
        rm "$TEMP"
        exit 1
      fi
    '';
  };

  # 4. 定义定时器 (每天执行一次更新脚本)
  systemd.timers.sing-box-update = {
    wantedBy = [ "timers.target" ];
    partOf = [ "sing-box-update.service" ];
    timerConfig = {
      # 每天凌晨 4:00 更新
      OnCalendar = "*-*-* 04:00:00";
      # 开机后 5 分钟也尝试更新一次
      OnBootSec = "5m";
      # 如果关机错过了时间，开机立即补跑
      Persistent = true;
    };
  };

}



