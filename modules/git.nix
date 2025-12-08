{ ... }:

{
  programs.git = {
    enable = true;
    # 你可以在这里加一些全局配置，比如默认分支名
    settings = {
      user = {
        name = "RXDA";
        email = "sxfscool@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}