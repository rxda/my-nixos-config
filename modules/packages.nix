{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # ============================================================
    # 系统工具与命令行增强
    # ============================================================
    zip # zip 压缩
    unzip # zip 解压
    xz # xz 高压缩率
    p7zip # 7z 压缩（支持多种格式）
    unrar # RAR 解压
    tree # 树状目录结构
    nix-output-monitor # Nix 构建进度条（nom）
    lsof # 查看打开的文件/端口占用
    sysstat # 性能监控（iostat, mpstat 等）
    lm_sensors # 硬件温度监控（sensors）
    ethtool # 网卡诊断与参数调整
    pciutils # PCI 设备查询（lspci）
    usbutils # USB 设备查询（lsusb）
    lshw # 完整硬件信息
    fastfetch # 系统信息展示
    util-linux # Linux 核心工具集
    eza # ls 现代替代品（图标、颜色、Git 状态）
    file # 文件类型识别
    ripgrep-all # 增强版 rg，支持 PDF/DOCX/压缩包等搜索
    gnugrep # GNU grep 文本搜索
    wl-clipboard # Wayland 剪贴板（wl-copy/wl-paste）
    libmtp # MTP 设备通信库
    jmtpfs # FUSE 挂载 MTP 设备（Android 文件传输）
    android-file-transfer # Android MTP 文件传输 GUI

    # ============================================================
    # 网络与代理
    # ============================================================
    # clash-meta                                # Clash Meta 内核（已改用 sing-box）
    # gui-for-singbox                           # Sing-box GUI（已改用 sing-box）
    openvpn # OpenVPN 客户端
    yt-dlp # YouTube/B站等视频下载
    ffmpeg_7 # 音视频编解码/转换
    vlc # 媒体播放器
    aria2 # 命令行多协议下载器
    filezilla # FTP/SFTP 图形客户端
    dnsutils # DNS 诊断（dig/nslookup）
    cifs-utils # SMB/CIFS 挂载
    waypipe # Wayland 远程桌面

    # ============================================================
    # 开发环境
    # ============================================================
    # --- Nix 工具链 ---
    nh # Nix Helper：极速构建/清理
    nix-init # 从 URL 自动生成 Nix 包配置
    nix-index # command-not-found
    direnv # 目录自动加载环境变量
    statix # Nix 代码静态检查
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default # 加密密钥管理
    nixpkgs-reviewFull # 审查 nixpkgs PR 变更

    # --- 编程语言与编译器 ---
    jdk25_headless # JDK 25（headless）
    pkg-configUpstream # rust-analyzer 依赖
    lldb # LLVM 调试器（Rust/C++ 调试）
    python314 # Python 3.14

    # --- 版本控制 ---
    git # 分布式版本控制
    gh # GitHub CLI
    git-filter-repo # Git 历史重写

    # --- 安卓调试 ---
    android-tools # ADB/Fastboot
    scrcpy # 电脑控制 Android 手机

    # --- API 与测试 ---
    reqable # API 抓包与调试工具

    # --- 编辑器与 AI 编码 ---
    jetbrains.idea # IntelliJ IDEA Ultimate
    jetbrains.datagrip # DataGrip 数据库管理 IDE
    ghostty # GPU 加速终端
    antigravity # Google AI Agent 编辑器
    claude-code # Anthropic Claude CLI 编码助手
    opencode # 开源 AI 编码助手（终端版）
    codex # Cursor 风格 AI 编辑器
    cc-switch # Claude Code 模型切换工具

    # ============================================================
    # 日常办公与社交
    # ============================================================
    google-chrome # Google Chrome 浏览器
    firefox # Mozilla Firefox 浏览器
    wpsoffice-cn # WPS Office 办公套件
    telegram-desktop # Telegram 桌面端
    wechat # 微信（UOS Linux 版）
    qq # QQ
    snipaste # 截图工具
    gpu-screen-recorder-gtk # GPU 加速录屏
    gnome-tweaks # GNOME 优化工具
    inputs.nur-xddxdd.legacyPackages.${pkgs.stdenv.hostPlatform.system}.baidunetdisk # 百度网盘
    inputs.nur-rxda.packages.${pkgs.stdenv.hostPlatform.system}.tonghuashun # 同花顺
    inputs.nur-rxda.packages.${pkgs.stdenv.hostPlatform.system}.bilibili-video-downloader # B站视频下载

    # ============================================================
    # 游戏与娱乐
    # ============================================================
    chiaki-ng # PS4/PS5 远程串流
  ];
}
