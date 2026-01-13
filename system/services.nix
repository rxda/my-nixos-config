{ config, pkgs, ... }:

{
  # --- 基础网络工具 ---
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # 二进制兼容 
  programs.nix-ld.enable = true;

  # --- Tailscale ---
  services.tailscale.enable = true;
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
        path = "/home/rxda/Documents";
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

  # --- 防火墙 ---
  networking.firewall = {
    enable = true;
    checkReversePath = false;
    trustedInterfaces = ["wlp4s0" "virbr0" "docker0" "tun0" "tailscale0"];
    # Samba wsdd 需要的端口
    allowedTCPPorts = [ 5357 ];
    allowedUDPPorts = [ 3702 ];
  };

  # earlyoom防止死机，反应非常快
  services.earlyoom.enable = true;

  # 启用 zram 交换内存，可以缓解物理内存不足，且比磁盘 swap 快得多
  zramSwap.enable = true;
}