# flake/common.nix
{ self, inputs, pkgs, ... }: {
  # 这个文件会被所有主机导入
  imports = [
    # 1. 引入 Agenix 和 VSCode Server
    inputs.agenix.nixosModules.default

    # 2. 引入 Home Manager 的通用配置
    inputs.home-manager.nixosModules.home-manager
    {
      # 这部分是两台机器完全一样的
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = { inherit inputs; };

      home-manager.users.rxda = {
        imports = [
          ../modules/home.nix
        ];
      };
    }

    ../system/desktop.nix
    ../system/virtualization.nix
    ../system/services.nix
    ../system/variables.nix
    ../system/singbox.nix
    ../system/packages.nix
    ../system/fcitx5-rime.nix
    ../system/config.nix

  ];

  # 3. 引入 VSCode 扩展的 overlay
  nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

  # --- 时区与语言 ---
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # --- 用户配置 ---
  users.users.rxda = {
    isNormalUser = true;
    description = "rxda";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
  };
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # --- Nix 核心设置 ---
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    substituters = [
      "https://rxda-cache.cachix.org"
      "https://cache.nixos.org" # 官方源
    ];

    # 2. 添加信任公钥
    trusted-public-keys = [
      "rxda-cache.cachix.org-1:LDGrYaB+dF7wh+uWMLjh5VsckzFnnCyGkMH1sKHN++g="
    ];

    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-users = [ "root" "@wheel" "rxda" ];
  };

  # --- 引导与内核 ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- 网络 ---
  networking.networkmanager.enable = true;
}
