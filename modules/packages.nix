{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # ============================================================
    # 系统工具与命令行增强
    # ============================================================
    # --- 压缩解压 ---
    zip # zip 压缩工具
    unzip # zip 解压工具
    xz # xz 高压缩率工具
    p7zip # 7z 压缩工具 (支持多种格式)

    # --- 系统监控与硬件 ---
    tree # 以树状图显示目录结构
    nix-output-monitor # (nom) 让 Nix 构建输出像进度条一样直观
    lsof # 查看当前系统打开的文件/端口占用
    sysstat # 系统性能监控工具 (iostat, mpstat 等)
    lm_sensors # 硬件温度监控 (sensors 命令)
    ethtool # 网卡硬件设置与诊断
    pciutils # 查看 PCI 设备 (lspci)
    usbutils # 查看 USB 设备 (lsusb)
    lshw # 显示硬件详细信息
    fastfetch # 那个显示 Linux Logo 和系统信息的帅气工具
    util-linux # Linux 核心工具集 (你提到用于修复 IDEA 运行 Java 问题)
    eza # ls 的现代替代品 (支持图标和颜色)
    file # 查看文件类型的工具
    gnome-tweaks # GNOME 优化工具 (修改字体、主题等)

    # ============================================================
    # 网络与代理 (科学上网)
    # ============================================================
    clash-meta # Clash 的 Meta 内核 (支持更多协议)
    gui-for-singbox # Sing-box 的图形界面
    openvpn # 传统的 VPN 客户端
    easytier # 简单的 P2P 组网工具 (类似 ZeroTier)
    yt-dlp # youtube下载器
    ffmpeg_7 # ffmpeg
    vlc # vlc播放器

    # --- 网络分析与下载 ---
    aria2 # 强大的命令行下载工具
    wireshark # 网络抓包分析神器
    fiddler-everywhere # HTTP/HTTPS 抓包调试代理
    baidupcs-go # 百度网盘的第三方 Go 语言客户端
    gnugrep # GNU 版本的 grep (搜索文本)
    filezilla # FTP客户端
    jmtpfs # FUSE filesystem for MTP devices like Android phones
    # ============================================================
    # 开发环境 (Dev)
    # ============================================================
    # --- Nix 相关 ---
    nh # Nix Helper: 极速构建 NixOS 的辅助工具
    nix-init # 自动将 URL 生成为 nix 软件包配置
    nix-index # 提供 command-not-found 功能 (查找命令属于哪个包)
    direnv # 进入目录自动加载环境变量 (开发神器)
    statix # 自动修复过时配置
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    # --- 编程语言与编译器 ---
    go # Go 语言环境
    jdk8 # Java 8 开发包 (为了兼容旧项目?)
    maven # Java 项目构建工具
    nodejs_24 # Node.js 24
    pnpm_10 # 快速的 Node 包管理器
    pkg-configUpstream # rust-analyzer依赖
    lldb # rust调试
    # --- 开发工具 ---
    git # 版本控制 (虽然有 programs.git，这里装一下防身)
    postman # API 接口测试工具
    android-tools # 安卓调试工具 (adb, fastboot)
    nixpkgs-reviewFull # nixpkg review工具  
    gh # github cli
    scrcpy # 安卓
    git-filter-repo # git历史修改

    # --- 编辑器与终端 ---
    jetbrains.idea # IntelliJ IDEA 旗舰版 (Java IDE)
    jetbrains.datagrip # DataGrip (数据库管理 IDE)
    yazi # 极速终端文件管理器 (用 Rust 写的)
    alacritty-graphics # 可能是指支持图形协议的 Alacritty 版本
    ghostty # 终端

    # ============================================================
    # 日常办公与社交
    # ============================================================
    google-chrome # 谷歌浏览器
    firefox # 火狐浏览器
    wpsoffice-cn # WPS Office (国产办公套件)
    telegram-desktop # Telegram 桌面端
    wechat-uos # 微信 (基于 UOS 版本的 Linux 客户端)
    waypipe

    # ============================================================
    # 娱乐与游戏
    # ============================================================
    spotify # 听歌
    netease-cloud-music-gtk # 网易云音乐 (GTK 版本，非官方)
    chiaki-ng # PS4/PS5 远程串流客户端
    prismlauncher # 最好用的 Minecraft 启动器
    protonplus # 管理 Steam Proton/Wine 版本的工具 (游戏兼容层)

    # ============================================================
    # 虚拟化
    # ============================================================
    OVMF # 虚拟机用的 UEFI 固件
  ];
}
