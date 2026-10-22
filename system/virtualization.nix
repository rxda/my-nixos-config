{ pkgs, ... }:

{
  # --- Docker ---
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = false; # 或者删除整个 rootless 块
      setSocketVariable = false; # 关键：阻止它向用户环境注入 DOCKER_HOST
    };
  };

  users.users.rxda.extraGroups = [ "docker" ];

  # emulatedSystems 生成注册；fixBinary 把解释器固化进内核，rootless 容器内才能用
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" ]; # 根据你要构建的架构调整
    preferStaticEmulators = true; # 关键：让 Docker 能正确调用静态 QEMU
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
