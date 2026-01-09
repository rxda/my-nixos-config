{ config, ... }:

{
  nix.registry = {
    my-templates = {
      to = { type = "path"; path = "${config.home.homeDirectory}/my-nixos-config/templates"; };
    };
  };

}