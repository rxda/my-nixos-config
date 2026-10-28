{ pkgs, inputs, ... }:

let
  agentPkgs = import inputs.nixpkgs-agents {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  # 用 symlinkJoin 包装原包输出，原包本身可走缓存，不重建
  deepseekHarnessWithBwrap = agentPkgs.symlinkJoin {
    name = "deepseek-harness-with-bwrap";
    paths = [ agentPkgs.deepseek-harness ];
    nativeBuildInputs = [ agentPkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/dsh \
        --prefix PATH : ${agentPkgs.lib.makeBinPath [ agentPkgs.bubblewrap ]}
    '';
  };
in
{
  home.packages = with agentPkgs; [
    codex
    cc-switch
    opencode
    chatgpt
    deepseekHarnessWithBwrap
  ];
}