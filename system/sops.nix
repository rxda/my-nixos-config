{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];

  # System services use the host SSH key to decrypt the shared secret file.
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../secrets/secrets.yaml;

    secrets."singbox-url" = {
      key = "common/singbox/url";
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };
}
