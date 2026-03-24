{ ... }:

{
  disko.devices = {
    disk = {
      main = {
        # ！！！注意：这里要根据你的硬盘修改，nvme 盘通常是 /dev/nvme0n1 ！！！
        # 终端输入 lsblk 确认
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # 1. EFI 引导分区
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            # 2. Btrfs 主分区
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # 强制格式化
                # 定义子卷
                subvolumes = {
                  # 根目录
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # Nix Store (存放系统包，必须开启压缩)
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # 用户家目录
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # 持久化目录 (如果你以后想玩重启即焚，就把重要文件放这)
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # 交换文件子卷
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "16G"; # 根据你内存大小调整
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
