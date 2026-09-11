{ pkgs, ... }:

{

  home.packages = [
    pkgs.nixd
    pkgs.nixfmt
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;

    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;

      userSettings = {
        # 开启自动保存，建议使用 afterDelay
        "files.autoSave" = "afterDelay";
        # 设置自动保存延迟（毫秒），1000 毫秒即 1 秒
        "files.autoSaveDelay" = 1000;
        "vsicons.dontShowNewVersionMessage" = true;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";

        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
            "options" = {
              # 这里的配置是 nixd 的灵魂，它能让你在写 Nix 选项时获得补全
              # 它可以关联你的 nixpkgs 路径
              "nixpkgs" = {
                "expr" = "import <nixpkgs> { }";
              };
            };
          };
        };

        # 终端字体（Nerd Font 显示图标）
        "terminal.integrated.fontFamily" = "FiraCode Nerd Font Mono";

        # 开启保存自动格式化
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };
      };
    };

    # VSCode 扩展按用途分组；扩展包来自 nix-vscode-extensions overlay。
    profiles.default.extensions = with pkgs; [
      # ============================================================
      # 主题与界面
      # ============================================================
      vscode-marketplace.akamud.vscode-theme-onedark # One Dark 主题
      vscode-marketplace.dlahmad.dracula-for-rust-theme # Dracula Rust 主题
      vscode-marketplace.vscode-icons-team.vscode-icons # 文件图标主题
      vscode-marketplace.github.github-vscode-theme # GitHub 官方主题

      # ============================================================
      # 编辑、格式化与数据查看
      # ============================================================
      vscode-marketplace.arturodent.find-and-transform # 查找与批量替换增强
      vscode-marketplace.clinyong.vscode-css-modules # CSS Modules 支持
      vscode-marketplace.esbenp.prettier-vscode # Prettier 格式化
      vscode-marketplace.everettjf.filter-line # 按内容过滤文本行
      vscode-marketplace.iliazeus.vscode-ansi # ANSI 转义序列高亮
      vscode-marketplace.isudox.vscode-jetbrains-keybindings # JetBrains 快捷键方案
      vscode-marketplace.janisdd.vscode-edit-csv # CSV 编辑器
      vscode-marketplace.mechatroner.rainbow-csv # CSV 列颜色与筛选
      vscode-marketplace.randomfractalsinc.geo-data-viewer # GeoJSON 等地理数据查看
      vscode-marketplace.redhat.vscode-xml # XML 编辑与验证
      vscode-marketplace.tamasfe.even-better-toml # TOML 语法支持
      vscode-marketplace.vstirbu.vscode-mermaid-preview # Mermaid 图表预览
      vscode-marketplace.wayou.vscode-todo-highlight # TODO、FIXME 高亮
      vscode-marketplace.yangdada.vscode-geojsonviewer # GeoJSON 查看器
      vscode-marketplace.yzhang.markdown-all-in-one # Markdown 编辑增强
      vscode-marketplace.quicktype.quicktype # JSON 等数据生成类型定义

      # ============================================================
      # Nix、Shell 与通用开发工具
      # ============================================================
      # vscode-marketplace.arrterian.nix-env-selector # Nix 环境选择器（可选）
      vscode-marketplace.jnoortheen.nix-ide # Nix 语法、补全与格式化
      vscode-marketplace.mads-hartmann.bash-ide-vscode # Bash 语言支持
      vscode-marketplace.mkhl.direnv # direnv 集成
      vscode-marketplace.irongeek.vscode-env # .env 文件高亮
      vscode-marketplace.ms-vscode.hexeditor # 十六进制编辑器

      # ============================================================
      # 编程语言与构建工具
      # ============================================================
      vscode-marketplace.fill-labs.dependi # 依赖更新与漏洞提示
      vscode-marketplace.golang.go # Go 语言支持
      vscode-marketplace.rust-lang.rust-analyzer # Rust Language Server
      vscode-marketplace.vue.volar # Vue 语言工具
      vscode-marketplace.biomejs.biome # JavaScript/TypeScript 格式化与检查
      vscode-marketplace.bradlc.vscode-tailwindcss # Tailwind CSS 智能提示

      # ============================================================
      # 远程开发与调试
      # ============================================================
      vscode-marketplace.ms-vscode-remote.remote-ssh # SSH 远程开发
      vscode-marketplace.ms-vscode-remote.remote-ssh-edit # 编辑远程 SSH 配置
      vscode-marketplace.ms-vscode.remote-explorer # 远程资源浏览器
      vscode-extensions.vadimcn.vscode-lldb # LLDB 调试器界面
      # vscode-marketplace-universal.vadimcn.vscode-lldb # 通用版 LLDB（可选）
    ];
  };
}
