# modules/gateway.nix
{ config, pkgs, lib, ... }:

let
  # === 在这里集中管理你的网络变量 ===
  cfg = {
    interface = "enp2s0";            # 你的物理网卡
    ipAddress = "192.168.32.110";    # NUC 的固定 IP
    gateway = "192.168.32.1";       # 你的主路由器 IP
    tunInterface = "tun0"; # Sing-box 创建的 TUN 网卡名
  };
in
{
  # 1. 固定 IP
  networking.interfaces.${cfg.interface}.useDHCP = false;
  networking.interfaces.${cfg.interface}.ipv4.addresses = [{
    address = cfg.ipAddress;
    prefixLength = 24;
  }];
  networking.defaultGateway = cfg.gateway;
  networking.nameservers = [ "223.5.5.5" ];

  # 2. 内核转发
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # 3. 防火墙与 NAT
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ cfg.tunInterface ];
    checkReversePath = false;
    allowedTCPPorts = [ 53 9090 ]; # DNS 和 Controller 端口
    allowedUDPPorts = [ 53 ];
  };
  networking.nat = {
    enable = true;
    internalInterfaces = [ cfg.tunInterface ];
    externalInterface = cfg.interface;
  };

  # 4. 禁用 systemd-resolved 避免端口冲突
  services.resolved.enable = false;
}