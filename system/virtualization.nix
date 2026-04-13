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

  environment.systemPackages = with pkgs; [
    OVMF
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

}
