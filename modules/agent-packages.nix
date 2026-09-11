{ pkgs, inputs, ... }:

let
  agentPkgs = import inputs.nixpkgs-agents {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  # Agent 相关软件使用独立的 nixpkgs-agents，便于单独更新。
  home.packages = with agentPkgs; [
    codex # OpenAI Codex 命令行编程 Agent
    cc-switch # AI 客户端和模型配置切换工具
  ];
}
