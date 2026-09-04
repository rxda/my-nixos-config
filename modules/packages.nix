{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # ============================================================
    # 系统工具与命令行增强
    # ============================================================

    # ============================================================
    # 网络与代理
    # ============================================================
    # clash-meta                                # Clash Meta 内核（已改用 sing-box）
    # gui-for-singbox                           # Sing-box GUI（已改用 sing-box）
    yt-dlp # YouTube/B站等视频下载
    ffmpeg_7 # 音视频编解码/转换
    vlc # 媒体播放器
    filezilla # FTP/SFTP 图形客户端

    # ============================================================
    # 开发环境
    # ============================================================
    # --- Nix 工具链 ---
    nix-init # 从 URL 自动生成 Nix 包配置
    nix-index # command-not-found
    statix # Nix 代码静态检查
    nixpkgs-reviewFull # 审查 nixpkgs PR 变更

    # --- 编程语言与编译器 ---
    jdk25_headless # JDK 25（headless）
    pkg-configUpstream # rust-analyzer 依赖
    lldb # LLVM 调试器（Rust/C++ 调试）
    python314 # Python 3.14

    # --- 版本控制 ---
    gh # GitHub CLI
    git-filter-repo # Git 历史重写

    # --- 安卓调试 ---
    # --- API 与测试 ---
    reqable # API 抓包与调试工具

    # --- 编辑器与 AI 编码 ---
    jetbrains.idea # IntelliJ IDEA Ultimate
    jetbrains.datagrip # DataGrip 数据库管理 IDE
    ghostty # GPU 加速终端
    # antigravity # Google AI Agent 编辑器

    # ============================================================
    # 日常办公与社交
    # ============================================================
    google-chrome # Google Chrome 浏览器
    firefox # Mozilla Firefox 浏览器
    wpsoffice-cn # WPS Office 办公套件
    telegram-desktop # Telegram 桌面端
    wechat # 微信（UOS Linux 版）
    # qq # QQ
    snipaste # 截图工具
    gpu-screen-recorder-gtk # GPU 加速录屏
    gnome-tweaks # GNOME 优化工具
    inputs.nur-xddxdd.legacyPackages.${pkgs.stdenv.hostPlatform.system}.baidunetdisk # 百度网盘
    # inputs.nur-rxda.packages.${pkgs.stdenv.hostPlatform.system}.tonghuashun # 同花顺
    # inputs.nur-rxda.packages.${pkgs.stdenv.hostPlatform.system}.bilibili-video-downloader # B站视频下载

    # ============================================================
    # 游戏与娱乐
    # ============================================================
    chiaki-ng # PS4/PS5 远程串流
  ];
}
