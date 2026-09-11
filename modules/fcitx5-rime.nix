{ pkgs, lib, ... }:

{
  # GNOME 扩展和 Rime 文件属于当前用户，由 Home Manager 管理。
  home.packages = with pkgs; [
    gnomeExtensions.appindicator # 托盘图标支持
    gnomeExtensions.kimpanel # Fcitx5 输入法面板支持
  ];

  home.file.".local/share/fcitx5/rime" = {
    source = "${pkgs.rime-ice}/share/rime-data";
    recursive = true;
  };

  home.file.".local/share/fcitx5/rime/default.custom.yaml".text = ''
    patch:
      schema_list:
        - schema: double_pinyin_flypy
        - schema: rime_ice

      menu/page_size: 5
  '';

  dconf.settings."org/gnome/shell".enabled-extensions = lib.mkAfter [
    pkgs.gnomeExtensions.appindicator.extensionUuid
    pkgs.gnomeExtensions.kimpanel.extensionUuid
  ];
}
