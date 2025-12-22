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
      signing = {
        key = "~/.ssh/id_ed25519.pub";
        signByDefault = true;
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      gpg.format = "ssh";
      
    };
  };
}