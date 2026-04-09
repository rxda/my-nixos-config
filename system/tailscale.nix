{ ... }:
{
  # --- Tailscale ---
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraSetFlags = [
      "--accept-routes=true"
      "--accept-dns=true"
    ];
  };

}
