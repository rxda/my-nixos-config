{ pkgs, ... }:

{
  # --- 系统级通用软件 ---
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    jq

    # 截图与 Wayland 工具 (如果你用 Niri 这里的很有用，GNOME 其实自带了)
    wl-clipboard
    inetutils

    # GNOME 插件
    gnome-shell-extensions
  ];

  # --- 环境变量 ---
  environment.sessionVariables =  {
    # Steam / Proton
    NIX_LD = "/run/current-system/sw/share/nix-ld/lib/ld.so";
    NIX_LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";

    # JetBrains Crack VM Options
    IDEA_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/idea.vmoptions";
    CLION_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/clion.vmoptions";
    PHPSTORM_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/phpstorm.vmoptions";
    GOLAND_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/goland.vmoptions";
    PYCHARM_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/pycharm.vmoptions";
    WEBSTORM_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/webstorm.vmoptions";
    WEBIDE_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/webide.vmoptions";
    RIDER_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/rider.vmoptions";
    DATAGRIP_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/datagrip.vmoptions";
    RUBYMINE_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/rubymine.vmoptions";
    DATASPELL_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/dataspell.vmoptions";
    AQUA_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/aqua.vmoptions";
    RUSTROVER_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/rustrover.vmoptions";
    GATEWAY_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/gateway.vmoptions";
    JETBRAINS_CLIENT_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/jetbrains_client.vmoptions";
    JETBRAINSCLIENT_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/jetbrainsclient.vmoptions";
    STUDIO_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/studio.vmoptions";
    DEVECOSTUDIO_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/devecostudio.vmoptions";
  };
}
