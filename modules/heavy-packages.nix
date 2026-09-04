{ pkgs, inputs, ... }:

let
  heavyPkgs = import inputs.nixpkgs-heavy {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with heavyPkgs; [
    jetbrains.idea # IntelliJ IDEA Ultimate
    jetbrains.datagrip # DataGrip 数据库管理 IDE
    wpsoffice-cn # WPS Office 办公套件
    wechat # 微信（UOS Linux 版）
  ];
}
