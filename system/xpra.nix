{ pkgs, ... }: {
  # 1. 开启 Xpra 服务
  environment.systemPackages = [
    pkgs.xpra
  ];

  # 2. 确保开启了 X11 转发支持（虽然 Xpra 自己有协议，但开着兼容性更好）
  services.openssh.settings.X11Forwarding = true;

  # 3. 必须开启 Linger（驻留），否则你断开 SSH 后，Systemd 会杀掉你的后台程序
  users.users.rxda.linger = true;
}
