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
    subscription = "/run/dae/subscription.url";

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

  systemd.services.dae = {
    # 在 dae 服务启动前，先执行我们的脚本
    preStart = ''
      # 创建目录
      mkdir -p /run/dae
      
      # 把解密后的 URL 内容写入 dae 即将读取的文件
      # ${config.age.secrets.singbox-url.path} 会被 Nix 替换成 "/run/agenix/singbox-url"
      cat ${config.age.secrets.singbox-url.path} > /run/dae/subscription.url
      
      # NixOS 上的 dae 服务默认以 "dae" 用户运行，
      # 我们需要确保它有权限读取这个文件
      chown dae:dae /run/dae
      chown dae:dae /run/dae/subscription.url
    '';
    
    # 告诉 systemd，我们的脚本可能会创建文件，需要 root 权限
    serviceConfig.PermissionsStartOnly = true;
  };
}