{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  age.secrets.hermes-auth = {
    file = ../../secrets/hermes-auth.age;
    owner = "rxda";
    group = "users";
    mode = "0400";
  };

  # Hermes 的公网 URL 通过 Agenix 注入，避免把域名写进 Git/Nix store。
  age.secrets.hermes-public-url = {
    file = ../../secrets/hermes-public-url.age;
    owner = "rxda";
    group = "users";
    mode = "0400";
  };

  # Hermes Dashboard 公网 URL 和 Basic Auth 凭据，运行时由 Agenix 解密。
  age.secrets.hermes-dashboard-auth = {
    file = ../../secrets/hermes-dashboard-auth.age;
    owner = "rxda";
    group = "users";
    mode = "0400";
  };

  age.secrets.cloudflare-tunnel-credentials = {
    file = ../../secrets/cloudflare-tunnel-credentials.age;
    owner = "root";
    mode = "0400";
  };

  # 仅在 link-eq12 的 Home Manager 配置中启用 Hermes，避免影响其他主机。
  home-manager.users.rxda.imports = [
    inputs.hermes-agent.homeManagerModules.default
    ../../modules/hermes.nix
  ];

  # Home Manager 的 user service 需要 linger，退出登录后仍保持运行。
  users.users.rxda.linger = true;

  services.cloudflared = {
    enable = true;
    tunnels."469cc5db-4750-4397-a786-17e640376ef9" = {
      credentialsFile = config.age.secrets.cloudflare-tunnel-credentials.path;
      # Public hostname/DNS route is managed in Cloudflare; no domain is stored here.
      default = "http://127.0.0.1:9119";
    };
  };

  # --- hostname ---
  networking.hostName = "link-eq12";

  # 1. N100 建议使用最新内核，对核显支持更好
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 2. 强制使用 modesetting 驱动 (不要用 "intel" legacy 驱动)
  services.xserver.videoDrivers = [ "modesetting" ];

  # 3. 显卡硬件加速配置
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # N100 必须使用 intel-media-driver (iHD)
      intel-media-driver

      # 这两个是通用的，可以留着
      libva-vdpau-driver
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      # Steam Remote Play 的客户端组件仍可能加载 32-bit VAAPI/VDPAU 驱动。
      intel-media-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # 4. 修复 Intel GPU 在某些电源状态下的屏幕闪烁/光标丢失问题
  boot.kernelParams = [
    "i915.enable_psr=0" # 关闭面板自刷新
    "i915.enable_guc=2" # 强制开启 GuC (Firmware loading)
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # sing-box 不开机启动
  systemd.services.sing-box.wantedBy = lib.mkForce [ ];

  # 关闭节能wifi
  networking.networkmanager.wifi.powersave = false;

  # 系统版本 (千万别删)
  system.stateVersion = "26.05";
}
