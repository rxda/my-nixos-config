{ inputs, config, pkgs, ... }:

{
  # 注意修改这里的用户名与用户目录
  home.username = "rxda";
  home.homeDirectory = "/home/rxda";

  # vscode扩展仓库
  # nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

  # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # 递归整个文件夹
  #   executable = true;  # 将其中所有文件添加「执行」权限
  # };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs;[
    # archives
    zip
    xz
    unzip
    p7zip
    # misc
    tree

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # system call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    clash-meta
    lshw
    neofetch
    busybox
    util-linux # 修复idea运行java程序问题
    #tools
    pritunl-client #openvpn
    google-chrome
    firefox
    wpsoffice-cn
    libreoffice-qt6-fresh
    baidupcs-go
    telegram-desktop
    aria2
    nh
    file
    nix-init
    gui-for-singbox
    sing-box
    sing-geoip
    clash-rs
    eza #ls替代
    #dev
    alacritty-graphics # rust 开发的终端
    vscode
    yazi
    direnv
    virtualbox
    spice-vdagent
    protonplus
    jetbrains.idea-ultimate
    jetbrains.datagrip
    pnpm_10
    code-cursor
    OVMF
    gnugrep
    wireshark
    fiddler-everywhere
    android-tools
    gnome-tweaks
    easytier
    jdk8
    postman
    maven
    #dev
    go
    rustup
    gcc
    nix-index
    # graalvmPackages.graalvm-ce
    #game
    chiaki-ng
    prismlauncher
    #china
    wechat-uos
    #music
    spotify
    netease-cloud-music-gtk
  ];

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "RXDA";
    userEmail = "sxfscool@gmail.com";
  };

  # 启用 starship，这是一个漂亮的 shell 提示符
  programs.starship = {
    enable = true;

    # 自定义配置
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };


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
      ls = "eza --icons";         # 用带图标的 eza 替代 ls
      l = "eza -1 --icons";       # 单列显示
      ll = "eza -l --icons";      # 显示详细信息 (类似 ls -l)
      la = "eza -la --icons";     # 显示详细信息并包含隐藏文件 (类似 ls -la)
      lt = "eza --tree --level=2 --icons"; # 以树状结构显示，最大深度2层
      update = "nixos-rebuild switch";
    };
    history.size = 1000000;
  };

  #vscode 扩展
  # programs.vscode = {
  #   enable = true;
  #   extensions = with pkgs; [
  #     vscode-extensions.akamud.vscode-theme-onedark
  #     vscode-extensions.arrterian.nix-env-selector
  #     vscode-extensions.arturodent.find-and-transform
  #     vscode-extensions.betterthantomorrow.calva
  #     vscode-extensions.betterthantomorrow.calva-spritz
  #     vscode-extensions.bierner.markdown-mermaid
  #     vscode-extensions.bpruitt-goddard.mermaid-markdown-syntax-highlighting
  #     vscode-extensions.clinyong.vscode-css-modules
  #     vscode-extensions.dlahmad.dracula-for-rust-theme
  #     vscode-extensions.docker.docker
  #     vscode-extensions.emilast.logfilehighlighter
  #     vscode-extensions.eriklynd.json-tools
  #     vscode-extensions.esbenp.prettier-vscode
  #     vscode-extensions.everettjf.filter-line
  #     vscode-extensions.fill-labs.dependi
  #     vscode-extensions.golang.go
  #     vscode-extensions.ianic.zig-language-extras
  #     vscode-extensions.ibm.output-colorizer
  #     vscode-extensions.iliazeus.vscode-ansi
  #     vscode-extensions.irongeek.vscode-env
  #     vscode-extensions.isudox.vscode-jetbrains-keybindings
  #     vscode-extensions.jakebecker.elixir-ls
  #     vscode-extensions.janisdd.vscode-edit-csv
  #     vscode-extensions.jnoortheen.nix-ide
  #     vscode-extensions.mads-hartmann.bash-ide-vscode
  #     vscode-extensions.marlon407.code-groovy
  #     vscode-extensions.mechatroner.rainbow-csv
  #     vscode-extensions.mkhl.direnv
  #     vscode-extensions.ms-azuretools.vscode-containers
  #     vscode-extensions.ms-azuretools.vscode-docker
  #     vscode-extensions.ms-python.autopep8
  #     vscode-extensions.ms-python.debugpy
  #     vscode-extensions.ms-python.isort
  #     vscode-extensions.ms-python.python
  #     vscode-extensions.ms-python.vscode-pylance
  #     vscode-extensions.ms-python.vscode-python-envs
  #     vscode-extensions.ms-toolsai.jupyter
  #     vscode-extensions.ms-toolsai.jupyter-keymap
  #     vscode-extensions.ms-toolsai.jupyter-renderers
  #     vscode-extensions.ms-toolsai.vscode-jupyter-cell-tags
  #     vscode-extensions.ms-toolsai.vscode-jupyter-slideshow
  #     vscode-extensions.ms-vscode-remote.remote-ssh
  #     vscode-extensions.ms-vscode-remote.remote-ssh-edit
  #     vscode-extensions.ms-vscode.cmake-tools
  #     vscode-extensions.ms-vscode.cpptools
  #     vscode-extensions.ms-vscode.cpptools-extension-pack
  #     vscode-extensions.ms-vscode.cpptools-themes
  #     vscode-extensions.ms-vscode.hexeditor
  #     vscode-extensions.ms-vscode.remote-explorer
  #     vscode-extensions.ms-vscode.vscode-typescript-next
  #     vscode-extensions.naco-siren.gradle-language
  #     vscode-extensions.pinage404.nix-extension-pack
  #     vscode-extensions.quicktype.quicktype
  #     vscode-extensions.randomfractalsinc.geo-data-viewer
  #     vscode-extensions.redhat.java
  #     vscode-extensions.redhat.vscode-xml
  #     vscode-extensions.rust-lang.rust-analyzer
  #     vscode-extensions.scala-lang.scala
  #     vscode-extensions.scalameta.metals
  #     vscode-extensions.shakram02.bash-beautify
  #     vscode-extensions.tabbyml.vscode-tabby
  #     vscode-extensions.tamasfe.even-better-toml
  #     vscode-extensions.tobias-faller.vt100-syntax-highlighting
  #     vscode-extensions.twxs.cmake
  #     vscode-extensions.vadimcn.vscode-lldb
  #     vscode-extensions.visualstudioexptteam.intellicode-api-usage-examples
  #     vscode-extensions.visualstudioexptteam.vscodeintellicode
  #     vscode-extensions.vmware.vscode-spring-boot
  #     vscode-extensions.vscjava.vscode-gradle
  #     vscode-extensions.vscjava.vscode-java-debug
  #     vscode-extensions.vscjava.vscode-java-dependency
  #     vscode-extensions.vscjava.vscode-java-pack
  #     vscode-extensions.vscjava.vscode-java-test
  #     vscode-extensions.vscjava.vscode-lombok
  #     vscode-extensions.vscjava.vscode-maven
  #     vscode-extensions.vscjava.vscode-spring-boot-dashboard
  #     vscode-extensions.vscode-icons-team.vscode-icons
  #     vscode-extensions.vstirbu.vscode-mermaid-preview
  #     vscode-extensions.vue.volar
  #     vscode-extensions.wayou.vscode-todo-highlight
  #     vscode-extensions.webfreak.debug
  #     vscode-extensions.yangdada.vscode-geojsonviewer
  #     vscode-extensions.yzhang.markdown-all-in-one
  #     vscode-extensions.zainchen.json
  #     vscode-extensions.ziglang.vscode-zig
  #     vscode-extensions.zxh404.vscode-proto3
  #   ];
  # };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
