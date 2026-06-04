{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];

    extensions = [
      "nix"
      "toml"
      "yaml"
      "dockerfile"
      "git-firefly"
      "html"
      "css"
      "json"
    ];

    userSettings = {
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      assistant = {
        version = "2";
        enabled = true;
      };
      base_keymap = "VSCode";
      vim_mode = false;
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
      ui_font_size = 16;
      buffer_font_size = 16;
      theme = "One Dark Pro";
      languages = {
        Nix = {
          language_servers = [ "nixd" ];
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
        };
      };
    };
  };

}
