{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    aria2
    ariang
  ];

  systemd.services.ariang = {
    enable = true;
    description = "Server ariang";
    path = [ pkgs.static-web-server ];
    unitConfig = {
      Type = "simple";
    };
    serviceConfig = {
      ExecStart = "${pkgs.static-web-server}/bin/static-web-server -p 30020 -d ${pkgs.ariang}";
    };
    wantedBy = [ "multi-user.target" ];
  };

  networking.firewall.allowedTCPPorts = [ 30020 6800 ];

  services.aria2 = {
    enable = true;
    openPorts = true;
    serviceUMask = "0002";
    settings = {
      "rpc-listen-all"= true;
      dir = "${config.users.users.rxda.home}/Downloads";
    };
    rpcSecretFile = "${config.users.users.rxda.home}/.config/aria2/aria2-rpc-token.txt";
  };

  users.users.rxda = {
    extraGroups = [ "aria2" ];
  };
}
