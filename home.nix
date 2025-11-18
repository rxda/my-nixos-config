{ inputs, config, pkgs, ... }:

{
  # 注意修改这里的用户名与用户目录
  home.username = "rxda";
  home.homeDirectory = "/home/rxda";


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
    openvpn
    #dev
    alacritty-graphics # rust 开发的终端
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
    nodejs_24
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
  # programs.git.settings = {
  #   enable = true;
  #   user = {
  #     name = "RXDA";
  #     email = "sxfscool@gmail.com";
  #   };
  # };
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

  # vscode 扩展
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    extensions = with pkgs; [
      vscode-marketplace.akamud.vscode-theme-onedark
      vscode-marketplace.arrterian.nix-env-selector
      vscode-marketplace.arturodent.find-and-transform
      vscode-marketplace.betterthantomorrow.calva
      vscode-marketplace.betterthantomorrow.calva-spritz
      vscode-marketplace.bierner.markdown-mermaid
      vscode-marketplace.bpruitt-goddard.mermaid-markdown-syntax-highlighting
      vscode-marketplace.clinyong.vscode-css-modules
      vscode-marketplace.dlahmad.dracula-for-rust-theme
      vscode-marketplace.docker.docker
      vscode-marketplace.emilast.logfilehighlighter
      vscode-marketplace.eriklynd.json-tools
      vscode-marketplace.esbenp.prettier-vscode
      vscode-marketplace.everettjf.filter-line
      vscode-marketplace.fill-labs.dependi
      vscode-marketplace.golang.go
      vscode-marketplace.ianic.zig-language-extras
      vscode-marketplace.ibm.output-colorizer
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
      vscode-marketplace.ms-azuretools.vscode-containers
      vscode-marketplace.ms-azuretools.vscode-docker
      vscode-marketplace.ms-python.autopep8
      vscode-marketplace.ms-python.debugpy
      vscode-marketplace.ms-python.isort
      vscode-marketplace.ms-python.python
      vscode-marketplace.ms-python.vscode-pylance
      vscode-marketplace.ms-python.vscode-python-envs
      vscode-marketplace.ms-toolsai.jupyter
      vscode-marketplace.ms-toolsai.jupyter-keymap
      vscode-marketplace.ms-toolsai.jupyter-renderers
      vscode-marketplace.ms-toolsai.vscode-jupyter-cell-tags
      vscode-marketplace.ms-toolsai.vscode-jupyter-slideshow
      vscode-marketplace.ms-vscode-remote.remote-ssh
      vscode-marketplace.ms-vscode-remote.remote-ssh-edit
      vscode-marketplace.ms-vscode.cmake-tools
      vscode-marketplace.ms-vscode.cpptools
      vscode-marketplace.ms-vscode.hexeditor
      vscode-marketplace.ms-vscode.remote-explorer
      vscode-marketplace.ms-vscode.vscode-typescript-next
      vscode-marketplace.naco-siren.gradle-language
      vscode-marketplace.jnoortheen.nix-ide
      vscode-marketplace.mkhl.direnv
      vscode-marketplace.arrterian.nix-env-selector
      vscode-marketplace.quicktype.quicktype
      vscode-marketplace.randomfractalsinc.geo-data-viewer
      vscode-marketplace.redhat.java
      vscode-marketplace.redhat.vscode-xml
      vscode-marketplace.rust-lang.rust-analyzer
      vscode-marketplace.scala-lang.scala
      vscode-marketplace.scalameta.metals
      vscode-marketplace.shakram02.bash-beautify
      vscode-marketplace.tabbyml.vscode-tabby
      vscode-marketplace.tamasfe.even-better-toml
      vscode-marketplace.tobias-faller.vt100-syntax-highlighting
      vscode-marketplace.twxs.cmake
      vscode-marketplace-universal.vadimcn.vscode-lldb
      vscode-marketplace.vmware.vscode-spring-boot
      vscode-marketplace.vscjava.vscode-gradle
      vscode-marketplace.vscjava.vscode-java-debug
      vscode-marketplace.vscjava.vscode-java-dependency
      vscode-marketplace.vscjava.vscode-java-pack
      vscode-marketplace.vscjava.vscode-java-test
      vscode-marketplace.vscjava.vscode-lombok
      vscode-marketplace.vscjava.vscode-maven
      vscode-marketplace.vscjava.vscode-spring-boot-dashboard
      vscode-marketplace.vscode-icons-team.vscode-icons
      vscode-marketplace.vstirbu.vscode-mermaid-preview
      vscode-marketplace.vue.volar
      vscode-marketplace.wayou.vscode-todo-highlight
      vscode-marketplace.webfreak.debug
      vscode-marketplace.yangdada.vscode-geojsonviewer
      vscode-marketplace.yzhang.markdown-all-in-one
      vscode-marketplace.zainchen.json
      vscode-marketplace.ziglang.vscode-zig
      vscode-marketplace.zxh404.vscode-proto3
    ];
  };

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
