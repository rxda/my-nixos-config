{ ... }:

{
  # Home Manager 模块：服务和 CLI 都归 rxda 用户管理。
  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    backend.mode = "dashboard";
    backend.port = 9119;
    settings.model.default = "anthropic/claude-sonnet-4";
  };

  programs.hermes-agent.enable = true;
}
