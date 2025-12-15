{ config, pkgs, ... }:

{
  # --- Docker ---
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # --- Libvirt (KVM/QEMU) ---
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  
  # 确保用户组在 configuration.nix 里已经加了 libvirtd
  # --- Incus ---
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
    preseed = {
      networks = [
        {
          config = {
            "ipv4.address" = "10.0.100.1/24";
            "ipv4.nat" = "true";
          };
          name = "incusbr0";
          type = "bridge";
        }
      ];
      profiles = [
        {
          devices = {
            eth0 = {
              name = "eth0";
              network = "incusbr0";
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              size = "35GiB";
              type = "disk";
            };
          };
          name = "default";
        }
      ];
      storage_pools = [
        {
          config = {
            source = "/var/lib/incus/storage-pools/default";
          };
          driver = "dir";
          name = "default";
        }
      ];
    };
  };
  networking.nftables.enable = true;
  # 开放防火墙端口，允许局域网访问 Incus API/UI
  networking.firewall.allowedTCPPorts = [ 8443 ];
  users.users.rxda.extraGroups = ["incus-admin"];
  networking.firewall.trustedInterfaces = [ "incusbr0" ];
}