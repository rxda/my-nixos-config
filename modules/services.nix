{ config, pkgs, ... }:

{
  # --- 基础网络工具 ---
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # --- Tailscale ---
  services.tailscale.enable = true;

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
    checkReversePath = "loose";
    trustedInterfaces = ["wlp4s0" "virbr0" "docker0"];
    # Samba wsdd 需要的端口
    allowedTCPPorts = [ 5357 ];
    allowedUDPPorts = [ 3702 ];
  };
}