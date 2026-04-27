{ pkgs, ... }:

{

  home.packages = [
    pkgs.nixd
    pkgs.nixfmt-rfc-style
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;

    profiles.default.userSettings = {
      # 开启自动保存，建议使用 afterDelay
      "files.autoSave" = "afterDelay";
      # 设置自动保存延迟（毫秒），1000 毫秒即 1 秒
      "files.autoSaveDelay" = 1000;

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

      # 开启保存自动格式化
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
      };
    };

    # 注意：这一大坨扩展列表
    profiles.default.extensions = with pkgs; [
      vscode-marketplace.akamud.vscode-theme-onedark
      # vscode-marketplace.arrterian.nix-env-selector
      vscode-marketplace.arturodent.find-and-transform
      vscode-marketplace.clinyong.vscode-css-modules
      vscode-marketplace.dlahmad.dracula-for-rust-theme
      vscode-marketplace.esbenp.prettier-vscode
      vscode-marketplace.everettjf.filter-line
      vscode-marketplace.fill-labs.dependi
      vscode-marketplace.golang.go
      vscode-marketplace.ianic.zig-language-extras
      vscode-marketplace.iliazeus.vscode-ansi
      vscode-marketplace.irongeek.vscode-env
      vscode-marketplace.isudox.vscode-jetbrains-keybindings
      vscode-marketplace.jakebecker.elixir-ls
      vscode-marketplace.janisdd.vscode-edit-csv
      vscode-marketplace.jnoortheen.nix-ide
      vscode-marketplace.mads-hartmann.bash-ide-vscode
      vscode-marketplace.marlon407.code-groovy
      vscode-marketplace.mechatroner.rainbow-csv
      vscode-marketplace.mkhl.direnv
      vscode-marketplace.ms-vscode-remote.remote-ssh
      vscode-marketplace.ms-vscode-remote.remote-ssh-edit
      vscode-marketplace.ms-vscode.cmake-tools
      vscode-marketplace.ms-vscode.cpptools
      vscode-marketplace.ms-vscode.hexeditor
      vscode-marketplace.ms-vscode.remote-explorer
      vscode-marketplace.naco-siren.gradle-language
      # vscode-marketplace.quicktype.quicktype
      vscode-marketplace.randomfractalsinc.geo-data-viewer
      vscode-marketplace.redhat.vscode-xml
      vscode-marketplace.rust-lang.rust-analyzer
      vscode-marketplace.tamasfe.even-better-toml
      vscode-marketplace.twxs.cmake
      # vscode-marketplace-universal.vadimcn.vscode-lldb  
      vscode-marketplace.vscode-icons-team.vscode-icons
      vscode-marketplace.vstirbu.vscode-mermaid-preview
      vscode-marketplace.vue.volar
      vscode-marketplace.wayou.vscode-todo-highlight
      vscode-marketplace.yangdada.vscode-geojsonviewer
      vscode-marketplace.yzhang.markdown-all-in-one
      vscode-marketplace.ziglang.vscode-zig
      vscode-marketplace.github.github-vscode-theme
      vscode-marketplace.quicktype.quicktype
      vscode-marketplace.biomejs.biome
      vscode-marketplace.bradlc.vscode-tailwindcss
      vscode-marketplace.rooveterinaryinc.roo-cline
      vscode-marketplace.anthropic.claude-code
      vscode-extensions.vadimcn.vscode-lldb
    ];
  };
}
