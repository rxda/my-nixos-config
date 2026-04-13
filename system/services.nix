{ pkgs, ... }:

{
  # --- 基础网络工具 ---
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  # 二进制兼容 
  programs.nix-ld.enable = true;
  services.envfs.enable = true;

  # --- ssh ---
  services.openssh.enable = true;

  # --- Steam ---
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # --- Samba (文件共享) ---
  services.samba = {
    enable = true;
    settings = {
      shared = {
        path = "/home/rxda";
        browseable = "yes";
        "read only" = "no";
        "valid users" = "rxda";
        "create mask" = "0755";
        "force user" = "rxda";
        "directory mask" = "0755";
      };
    };
    openFirewall = true;
  };
  # Windows 发现服务
  services.samba-wsdd.enable = true;

  networking.nftables.enable = true;
  # --- 防火墙 ---
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "wlp4s0" "virbr0" "docker0" "tun0" "tailscale0" ];
    # Samba wsdd 需要的端口
    allowedTCPPorts = [ 5357 5005 ];
    allowedUDPPorts = [ 3702 ];
  };

  # earlyoom防止死机，反应非常快
  services.earlyoom.enable = true;

  # 启用 zram 交换内存，可以缓解物理内存不足，且比磁盘 swap 快得多
  zramSwap.enable = true;

  # webdav
  # Dufs 没有内置的复杂 service 配置，可以用 systemd.services 简单包装
  systemd.services.dufs = {
    description = "Dufs WebDAV Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.dufs}/bin/dufs /home/rxda -p 5005 -a rxda:Admin123!@/:rw -A";
      Restart = "always";
      User = "rxda"; # 如果需要访问特定权限目录，也可以指定普通用户
    };
  };

}
