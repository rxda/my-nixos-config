{ inputs, ... }:

{
  nix.registry = {
    my-templates = {
      flake = inputs.my-templates;
    };
  };

}
