# rxda's NixOS Configurations

基于 [Flake](https://nixos.wiki/wiki/Flakes) 架构的 NixOS 配置仓库，管理两台主机（`link-eq12` 和 `xiaomi-notebook`）的系统配置、桌面环境、开发工具及各类服务。

## 目录结构

```
.
├── flake.nix                          # Flake 入口，定义 inputs 和 outputs 框架
├── flake.lock                         # 锁定所有 inputs 的版本
│
├── flake/                             # Flake 配置碎片（由 flake-parts 自动导入）
│   ├── default.nix                    # 定义 nixosConfigurations（两台主机）
│   └── common.nix                     # 两台主机共享的 NixOS 模块导入与通用配置
│
├── hosts/                             # 主机级配置（每台机器独有）
│   ├── link-eq12/                     # N100 小主机 (EQ12)
│   │   ├── configuration.nix          # 主机特有配置（内核、显卡驱动等）
│   │   ├── hardware-configuration.nix # 硬件自动生成的配置
│   │   └── disko.nix                  # 磁盘分区布局（Btrfs 子卷 + 交换文件）
│   └── xiaomi-notebook/               # 小米笔记本
│       ├── configuration.nix          # 主机特有配置（NVIDIA 双显卡等）
│       └── hardware-configuration.nix # 硬件自动生成的配置
│
├── modules/                           # Home Manager 用户级模块
│   ├── home.nix                       # Home Manager 入口，导入所有子模块
│   ├── packages.nix                   # 用户级软件包清单
│   ├── shell.nix                      # Shell 配置（Zsh + Starship + Atuin + Direnv）
│   ├── git.nix                        # Git + SSH 配置
│   ├── vscode.nix                     # VS Code 配置与扩展列表
│   ├── gnome.nix                      # GNOME 桌面配置（壁纸、扩展、快捷键、dconf）
│   └── template.nix                   # Nix 模板注册（my-templates）
│
├── system/                            # 系统级 NixOS 模块
│   ├── config.nix                     # 系统版本信息
│   ├── desktop.nix                    # 桌面环境（GNOME + Pipewire + 字体 + RDP）
│   ├── packages.nix                   # 系统级基础包
│   ├── variables.nix                  # 系统级软件包 + 环境变量（JetBrains VM Options 等）
│   ├── services.nix                   # 系统服务（SSH、Samba、Steam、Dufs、earlyoom、zram）
│   ├── virtualization.nix             # 虚拟化（Docker rootless + Libvirt/KVM）
│   ├── singbox.nix                    # Sing-box 代理服务（含订阅更新脚本）
│   ├── tailscale.nix                  # Tailscale 组网
│   ├── fcitx5-rime.nix                # 输入法（Fcitx5 + 雾凇拼音）
│   ├── agenix.nix                     # Agenix 加密凭据管理
│   ├── aria2.nix                      # Aria2 下载服务 + AriaNg Web 面板
│   ├── gateway.nix                    # 网关模式（NAT + 转发，用于旁路由）
│   ├── xpra.nix                       # Xpra 远程桌面服务
│   └── disable-hibernate.nix          # 禁用休眠（仅 link-eq12）
│
├── secrets/                           # 加密凭据（Agenix）
│   ├── secrets.nix                    # 公钥映射定义
│   └── singbox-url.age                # 订阅加密
│
├── scripts/                           # 辅助脚本
│   ├── tc.sh                          # 限速脚本（tc 流量控制）
│   └── untc.sh                        # 取消限速脚本
│
├── docs/                              # 文档
│   └── disko.md                       # Disko 分区安装指南
│
├── .github/                           # GitHub 相关配置
│
├── last-built-nixpkgs.txt             # 上次构建的 nixpkgs 版本记录
└── last-hashes.txt                    # 哈希缓存
```

## 主机说明

| 主机名 | 硬件 | 用途 | 特点 |
|--------|------|------|------|
| [`link-eq12`](hosts/link-eq12/configuration.nix) | N100 迷你主机 (EQ12) | 家庭服务器 / 旁路由 | 最新内核、Intel 核显加速、禁用休眠、Disko 自动分区 |
| [`xiaomi-notebook`](hosts/xiaomi-notebook/configuration.nix) | 小米笔记本 | 日常办公 / 开发 | NVIDIA 双显卡（Optimus）、GNOME 桌面 |

## 核心架构

### Flake 结构

[`flake.nix`](flake.nix) 定义了所有外部依赖（inputs），通过 [`flake-parts`](https://github.com/hercules-ci/flake-parts) 将配置拆分到 [`flake/`](flake/) 目录：

- [`flake/default.nix`](flake/default.nix) — 定义两台主机的 `nixosConfigurations`
- [`flake/common.nix`](flake/common.nix) — 两台主机共享的配置（用户、时区、Nix 设置、系统模块导入）

### 配置分层

```
flake.nix
  └─ flake/default.nix          # 主机定义
       └─ flake/common.nix      # 共享配置
            ├─ system/*.nix     # 系统级模块（桌面、服务、虚拟化...）
            └─ modules/home.nix # Home Manager 用户级模块
                 ├─ modules/packages.nix
                 ├─ modules/shell.nix
                 ├─ modules/git.nix
                 ├─ modules/vscode.nix
                 ├─ modules/gnome.nix
                 └─ modules/template.nix
```

### 关键依赖

| 依赖 | 用途 |
|------|------|
| [`nixpkgs`](https://github.com/NixOS/nixpkgs) (nixos-unstable) | 主软件源 |
| [`home-manager`](https://github.com/nix-community/home-manager) | 用户级配置管理 |
| [`agenix`](https://github.com/ryantm/agenix) | 加密凭据管理 |
| [`disko`](https://github.com/nix-community/disko) | 磁盘分区声明式配置 |
| [`nixos-hardware`](https://github.com/NixOS/nixos-hardware) | 硬件优化配置 |
| [`nix-vscode-extensions`](https://github.com/nix-community/nix-vscode-extensions) | VS Code 扩展 Nix 化 |
| [`fenix`](https://github.com/nix-community/fenix) | Rust 工具链管理 |
| [`sing-box-unstable`](https://github.com/rxda/sing-box-flake) | Sing-box 最新版 |
| [`nur-xddxdd`](https://github.com/xddxdd/nur-packages) | 第三方包（百度网盘等） |

## 常用命令

```bash
# 构建并切换系统
sudo nixos-rebuild switch --flake .

# 仅构建不切换（测试）
sudo nixos-rebuild build --flake .

# 使用 nh 快速构建
nh os switch

# 更新 flake.lock
nix flake update

# 编辑加密凭据
agenix -e secrets/singbox-url.age

# 使用 Disko 分区并安装（新机器）
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./flake.nix#link-eq12
sudo nixos-install --flake .#link-eq12
```

## 系统服务一览

| 服务 | 端口 | 说明 |
|------|------|------|
| [Sing-box](system/singbox.nix) | - | Sing-box服务（TUN 模式），含自动更新订阅脚本 |
| [Tailscale](system/tailscale.nix) | - | 虚拟组网 |
| [Aria2](system/aria2.nix) | `6800` / `30020` | 下载服务 + AriaNg Web 面板 |
| [Samba](system/services.nix) | `445` | 文件共享 |
| [Dufs](system/services.nix) | `5005` | WebDAV 文件服务 |
| [SSH](system/services.nix) | `22` | 远程登录 |
| [GNOME RDP](system/desktop.nix) | `3389` | 远程桌面 |
| [Xpra](system/xpra.nix) | - | 远程桌面（基于 X11） |
| [Docker](system/virtualization.nix) | - | 容器（Rootless 模式） |
| [Libvirt](system/virtualization.nix) | - | KVM/QEMU 虚拟机 |
| [earlyoom](system/services.nix) | - | 内存不足时自动杀进程防死机 |
| [zram](system/services.nix) | - | 压缩内存交换 |

## 许可证

MIT
