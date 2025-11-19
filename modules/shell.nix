{ pkgs, ... }:

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
}