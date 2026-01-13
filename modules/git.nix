_:

{
  programs.git = {
    enable = true;
    signing = {
        key = "~/.ssh/id_ed25519.pub";
        signByDefault = true;
    };
    # 你可以在这里加一些全局配置，比如默认分支名
    settings = {
      user = {
        name = "RXDA";
        email = "sxfscool@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      gpg.format = "ssh";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
    };
  };
}