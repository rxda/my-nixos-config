{ pkgs, inputs, ... }:

let
  agentPkgs = import inputs.nixpkgs-agents {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with agentPkgs; [
    codex
    cc-switch
  ];
}
