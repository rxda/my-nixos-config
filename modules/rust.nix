{ config, pkgs, lib, ... }:
{
  # 1. 安装必要的工具
  home.packages = with pkgs; [
    # Rust 工具链 (建议用 rustup 管理 rust 版本，比 nixpkgs 直接装更灵活)
    rustup 
    
    # 编译加速三件套
    sccache  # 编译缓存
    mold     # 现代高速链接器
    (lib.lowPrio clang)    # 用作 mold 的驱动程序
  ];

  # 2. 设置环境变量
  home.sessionVariables = {
    # 指定 sccache 缓存存放在哪里 (可选，默认在 ~/.cache/sccache)
    SCCACHE_DIR = "${config.home.homeDirectory}/.cache/sccache";
    # 可以在终端输入 `sccache -s` 查看缓存命中率
  };

  # 3. 生成全局 Cargo 配置
  # 这是魔法发生的地方
  home.file.".cargo/config.toml".text = ''
    [build]
    # 使用 sccache 包装器
    rustc-wrapper = "${pkgs.sccache}/bin/sccache"
    # 全局 Target 目录
    target-dir = "${config.home.homeDirectory}/.cargo/target_cache"

    [target.x86_64-unknown-linux-gnu]
    # 指定 clang 为驱动
    linker = "${pkgs.clang}/bin/clang"
    # 指定 mold 为链接器
    rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/ld.mold"]
  '';
}