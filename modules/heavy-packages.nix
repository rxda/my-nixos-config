{ pkgs, inputs, ... }:

let
  heavyPkgs = import inputs.nixpkgs-heavy {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  # 体积较大或运行时依赖较重的包，统一来自独立的 nixpkgs-heavy。
  home.packages = with heavyPkgs; [
    # ============================================================
    # 媒体与网络工具
    # ============================================================
    ffmpeg_7 # 音视频编解码、转码与处理工具
    vlc # 支持多种格式的桌面媒体播放器
    filezilla # FTP、FTPS 和 SFTP 文件传输客户端
    reqable # HTTP/HTTPS 抓包与 API 调试工具

    # ============================================================
    # 开发环境
    # ============================================================
    lldb # LLVM 调试器，支持 C、C++ 和 Rust 调试
    python3 # Python 3 解释器与标准库

    # ============================================================
    # 桌面应用
    # ============================================================
    google-chrome # Google Chrome 浏览器
    firefox # Firefox 浏览器
    telegram-desktop # Telegram 桌面客户端
    snipaste # 截图与贴图工具
    gpu-screen-recorder-gtk # GPU 加速屏幕录制工具
    inputs.nur-xddxdd.legacyPackages.${pkgs.stdenv.hostPlatform.system}.baidunetdisk # 百度网盘客户端

    # ============================================================
    # 游戏与娱乐
    # ============================================================
    chiaki-ng # PS4/PS5 远程串流客户端
    spotify # Spotify 音乐客户端

    # ============================================================
    # IDE 与办公
    # ============================================================
    jetbrains.idea # IntelliJ IDEA 集成开发环境
    jetbrains.datagrip # JetBrains 数据库开发工具
    wpsoffice-cn # WPS Office 办公套件
    wechat # 微信桌面客户端
  ];
}
