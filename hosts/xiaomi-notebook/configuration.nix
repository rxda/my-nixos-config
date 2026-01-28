{ config, ... }:

{
  # --- hostname ---
  networking.hostName = "xiaomi-notebook";

  # OpenGL
  hardware.graphics.enable = true;

  # 加载驱动
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # 系统版本 (千万别删)
  system.stateVersion = "24.11";
}
