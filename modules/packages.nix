{ pkgs, inputs, ... }:

{
  # 主 nixpkgs 中的轻量、常用包。
  home.packages = with pkgs; [
    # ============================================================
    # 网络与媒体工具
    # ============================================================

    yt-dlp # 视频下载工具，支持 YouTube、B 站等网站

    # ============================================================
    # Nix 开发与维护
    # ============================================================
    nix-init # 根据软件 URL 自动生成 Nix 包模板
    nix-index # 为 command-not-found 提供 Nix 包索引
    statix # Nix 静态检查与代码规范检查
    nixpkgs-reviewFull # 本地构建和审查 nixpkgs PR

    pkg-configUpstream # 为源码构建提供编译器和库的查询信息

    git-filter-repo # Git 历史重写与清理工具

    # ============================================================
    # 终端与桌面辅助
    # ============================================================
    ghostty # GPU 加速终端模拟器
    gnome-tweaks # GNOME 桌面高级设置工具

    # ============================================================
    # 可选包（按需取消注释）
    # ============================================================
    # inputs.nur-rxda.packages.${pkgs.stdenv.hostPlatform.system}.tonghuashun # 同花顺行情软件
    # inputs.nur-rxda.packages.${pkgs.stdenv.hostPlatform.system}.bilibili-video-downloader # B 站视频下载器
  ];
}
