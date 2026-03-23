{ pkgs, ... }:

{
  # --- Docker ---
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # 3. 安装相关工具
  environment.systemPackages = with pkgs; [
    # waydroid x86转义arm
    waydroid-helper
  ];

  # --- Libvirt (KVM/QEMU) ---
  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "suspend"; # 宿主机关闭时，虚拟机进入 Managed Save 状态
    onBoot = "ignore"; # 宿主机启动时，不自动开启虚拟机
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # 确保用户组在 configuration.nix 里已经加了 libvirtd
  networking.nftables.enable = true;

  # waydroid 
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
}
