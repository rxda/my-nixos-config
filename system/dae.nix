{ config, pkgs, inputs, ... }: 

{

  # 1. 引入 dae 模块
  imports = [
      inputs.daeuniverse.nixosModules.dae
  ];

  # 2. 开启内核转发功能 (这是做网关的必须步骤)
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # 2. 修改 dae 的配置
  services.dae = {
    enable = true;

    # 我们不再直接设置 subscription
    # 而是让 dae 从一个临时文件里读取
    subscription = builtins.readFile config.age.secrets.singbox-url.path;

    config = ''
      global {
        # 你的物理网卡名称 (用 `ip a` 命令查看，很可能是 eno1)
        lan_interface: enp2s0
        wan_interface: auto
        log_level: info
      }

      routing {
        # 简单高效的分流规则
        # 国内域名和 IP 直连
        geosite(cn) -> direct
        geoip(cn) -> direct

        # (可选) 拦截广告
        geosite(category-ads-all) -> block

        # (可选) 让BT流量直连
        # process_name(qbittorrent) -> direct
        
        # 剩下的所有流量都走代理
        fallback: proxy
      }
    '';
  };
}