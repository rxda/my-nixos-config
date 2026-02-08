# Disko安装系统


## 修改hardware-configuration.nix
删除 fileSystems."/" = { ... };
删除 fileSystems."/boot" = { ... };
删除 swapDevices = [ ... ];

## 使用 nix run 直接运行 disko, --mode disko 表示只进行分区格式化挂载，不安装系统
sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko -- --mode disko ./flake.nix#

## 安装系统
sudo nixos-install --flake .#主机名