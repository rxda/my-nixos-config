{ ... }:

{

  age.secrets.hermes-auth = {
    file = ../../secrets/hermes-auth.age;
    owner = "rxda";
    group = "users";
    mode = "0400";
  };

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

  programs.hermes-agent.enable = true;
}
