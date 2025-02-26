{ config, pkgs, ... }:

{
  # 启用docker虚拟化
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  # 将用户添加到docker用户组
  users.users.rxda.extraGroups = [ "docker" ];

}