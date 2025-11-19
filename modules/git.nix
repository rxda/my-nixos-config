{ ... }:

{
  programs.git = {
    enable = true;
    userName = "RXDA";
    userEmail = "sxfscool@gmail.com";
    
    # 你可以在这里加一些全局配置，比如默认分支名
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}