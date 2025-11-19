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
}