{ ... }:

{

  # Home Manager 模块：服务和 CLI 都归 rxda 用户管理。
  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    backend = {
      mode = "dashboard";
      host = "127.0.0.1";
      port = 9119;
    };

    # 从 Agenix 恢复已完成的 Nous Portal OAuth 登录状态。
    # false 保证 Hermes 运行时刷新后的 token 不会被每次激活覆盖。
    authFile = "/run/agenix/hermes-auth";
    authFileForceOverwrite = false;

    settings = {
      model.default = "upstage/solar-pro4:free";
    };
  };

  # Dashboard 的公网 URL 和 Basic Auth 凭据由 Agenix 在运行时注入。
  # 不使用 services.hermes-agent.environmentFiles，避免把这些变量注入 gateway。
  systemd.user.services.hermes-backend.Service.EnvironmentFile = [
    "/run/agenix/hermes-dashboard-auth"
  ];

  programs.hermes-agent.enable = true;
}
