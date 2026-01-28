{ pkgs, ... }:
{
  programs.zsh.enable = true;

  environment.systemPackages = [ pkgs.cacert ];

}
