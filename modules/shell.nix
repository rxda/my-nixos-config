{ ... }:

{
  # Starship 提示符
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # Zsh 配置
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      ls = "eza --icons";
      l = "eza -1 --icons";
      ll = "eza -l --icons";
      la = "eza -la --icons";
      lt = "eza --tree --level=2 --icons";
      update = "sudo nixos-rebuild switch --flake ."; # 稍微修正了一下常用命令
    };
    history.size = 1000000;
  };

  # 既然启用了 direnv，顺便在这里集成
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    # 自动同步
    flags = [ "--disable-up-arrow" ]; # 如果你不想接管上方向键
    settings = {
      auto_sync = true;
      sync_frequency = "5m"; # 每 5 分钟同步一次
      sync_address = "https://api.atuin.sh"; # 官方服务器
      search_mode = "fuzzy";
      history_filter = [
        "^ls" # 过滤以 ls 开头的命令（包括 ls -la 等）
        "^cd" # 过滤以 cd 开头的命令
        "^pwd$" # 仅过滤完全匹配 pwd 的命令
        "^exit$" # 过滤退出命令
        "^clear$" # 过滤清屏
        "^history" # 过滤查看历史的命令
      ];
    };
  };
}
