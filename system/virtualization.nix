{ pkgs, ... }:

{
  # --- Docker ---
  # virtualisation.docker = {
  #   enable = true;
  #   rootless = {
  #     enable = true;
  #     setSocketVariable = true;
  #   };
  # };

  # podman
  # 1. 开启 Podman
  virtualisation.podman = {
    enable = true;

    # 创建 docker 别名，让你直接运行 docker ps, docker run 等
    dockerCompat = true;

    # 开启 Docker 兼容 Socket
    # 这让普通的 docker-compose 和其它依赖 Docker 服务的工具能直接使用 Podman
    dockerSocket.enable = true;

    # 启用容器间 DNS 解析（Compose 必须，否则容器间无法通过名称访问）
    defaultNetwork.settings.dns_enabled = true;
  };

  # 2. 解决“镜像源选择”问题 (Registries)
  # 明确告诉 Podman 默认搜索 docker.io，这样拉取 alpine 时就不会再跳出菜单让你选了
  virtualisation.containers.registries.search = [ "docker.io" ];

  # 3. 安装相关工具
  environment.systemPackages = with pkgs; [
    # waydroid x86转义arm
    waydroid-helper
    podman-compose # Podman 官方的 Compose 实现
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
