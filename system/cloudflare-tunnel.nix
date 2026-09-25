{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.cloudflare-tunnel;
in
{
  options.services.cloudflare-tunnel = {
    enable = lib.mkEnableOption "Cloudflare Tunnel";

    tokenFile = lib.mkOption {
      type = lib.types.str;
      default = "/etc/cloudflared/tunnel-token";
      description = ''
        File containing the token of a remotely-managed Cloudflare Tunnel.
        The file is read by cloudflared at runtime and is not embedded into
        the Nix store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.cloudflared ];

    users.groups.cloudflared = { };
    users.users.cloudflared = {
      isSystemUser = true;
      group = "cloudflared";
      description = "Cloudflare Tunnel service user";
    };

    systemd.services.cloudflare-tunnel = {
      description = "Cloudflare Tunnel";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];

      # Do not enter a restart loop before the token has been installed.
      unitConfig.ConditionFileNotEmpty = cfg.tokenFile;

      serviceConfig = {
        User = "cloudflared";
        Group = "cloudflared";
        ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token-file ${cfg.tokenFile}";
        Restart = "on-failure";
        RestartSec = "5s";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };
    };
  };
}
