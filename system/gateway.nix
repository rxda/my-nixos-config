# modules/gateway.nix
{ config, pkgs, lib, ... }:

{

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