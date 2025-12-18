{ config, pkgs, inputs, ... }: 

{

  age.secrets.singbox-url = {
    file = ../secrets/singbox-url.age;
    owner = "root"; # 因为是 systemd (root) 要读它
    mode = "400";
  };

  # 1. 引入 dae 模块
  imports = [
      inputs.daeuniverse.nixosModules.daed
  ];

  # 2. 开启内核转发功能 (这是做网关的必须步骤)
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # 2. 修改 dae 的配置
  services.dae = {
    enable = true;

    # 1. 告诉 dae，你的订阅在 /run/dae/subscription.url 这个临时文件里
    subscription = "/run/dae/subscription.url";
    
    # 2. preStart 脚本在“激活施工”阶段运行
    preStart = ''
      # 在这个阶段，/run 目录是存在的
      mkdir -p /run/dae
      
      # config.age.secrets.singbox-url.path 在这里被 Nix 替换成字符串 "/run/agenix/singbox-url"
      # cat 命令在运行时读取这个文件
      cat ${config.age.secrets.singbox-url.path} > /run/dae/subscription.url
      
      chown dae:dae /run/dae/subscription.url
    '';

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