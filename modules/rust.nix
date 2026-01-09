{ config, pkgs, lib, inputs,... }:

let
  # 1. 定义系统架构变量（如果你没定义的话）
  system = pkgs.system;

  # 2. 将基础工具链和 musl 目标“缝合”成一个逻辑包
  rust-toolchain = inputs.fenix.packages.${system}.combine [
    inputs.fenix.packages.${system}.stable.toolchain
    inputs.fenix.packages.${system}.targets.x86_64-unknown-linux-musl.stable.rust-std
  ];
in
{
  # 1. 安装必要的工具
  home.packages = with pkgs; [
    rust-toolchain
    pkgs.pkgsCross.musl64.stdenv.cc
    pkgs.pkgsCross.mingwW64
    musl
    # 编译加速三件套
    sccache  # 编译缓存
    mold     # 现代高速链接器
    (lib.lowPrio clang)    # 用作 mold 的驱动程序
  ];

  # 2. 设置环境变量
  home.sessionVariables = {
    # 指定 sccache 缓存存放在哪里 (可选，默认在 ~/.cache/sccache)
    # 可以在终端输入 `sccache -s` 查看缓存命中率
    SCCACHE_DIR = "${config.home.homeDirectory}/.cache/sccache";
    # musl交叉编译环境变量
    CC_x86_64_unknown_linux_musl = "x86_64-unknown-linux-musl-gcc";
    # 某些 crate 还需要设置这个
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER = "x86_64-unknown-linux-musl-gcc";
    # 针对 Windows 目标的配置
    CARGO_TARGET_X86_64_PC_WINDOWS_GNU_LINKER = "x86_64-w64-mingw32-gcc";
    
    # 针对 Windows 目标的库路径（解决 lpthread 报错）
    CARGO_TARGET_X86_64_PC_WINDOWS_GNU_RUSTFLAGS = "-L native=${winPkgs.windows.pthreads}/lib";
  };

  # 3. 生成全局 Cargo 配置
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