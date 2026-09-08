{ pkgs, inputs, ... }:
{
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    cacert

    # 通用命令行与硬件工具
    zip
    unzip
    xz
    p7zip
    unrar
    tree
    nix-output-monitor
    nh
    lsof
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
    lshw
    fastfetch
    util-linux
    eza
    file
    ripgrep-all
    gnugrep
    wl-clipboard
    libmtp
    android-file-transfer

    # 通用网络工具
    openvpn
    dnsutils
    cifs-utils
    waypipe

    # 其他模块/用户都会用到的工具
    aria2
    android-tools # adb / fastboot
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    vim
    wget
    jq
    inetutils
    # GNOME 插件
    gnome-shell-extensions
  ];

}
