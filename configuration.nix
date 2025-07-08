# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Chinese input
  i18n.inputMethod = {
    type = "ibus";
    enable = true;
    ibus.engines = with pkgs.ibus-engines; [
      libpinyin
      rime
    ];
  };
  
  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      # sarasa-gothic  #更纱黑体
      source-code-pro
      hack-font
      jetbrains-mono
      wqy_microhei
      wqy_zenhei
    ];
  };


  # Nvidia Driver
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };



  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };


  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;
  services.gnome.core-apps.enable = true;


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rxda = {
    isNormalUser = true;
    description = "rxda";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  # Zsh
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    tailscale
    jq
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    gnome-shell-extensions
    gnomeExtensions.dash-to-dock
  ];

  environment.sessionVariables = rec {
    # env for steam pronton
    NIX_LD = "/run/current-system/sw/share/nix-ld/lib/ld.so";
    NIX_LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
    # env for jetbra
    IDEA_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/idea.vmoptions";
    CLION_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/clion.vmoptions";
    PHPSTORM_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/phpstorm.vmoptions";
    GOLAND_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/goland.vmoptions";
    PYCHARM_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/pycharm.vmoptions";
    WEBSTORM_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/webstorm.vmoptions";
    WEBIDE_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/webide.vmoptions";
    RIDER_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/rider.vmoptions";
    DATAGRIP_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/datagrip.vmoptions";
    RUBYMINE_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/rubymine.vmoptions";
    DATASPELL_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/dataspell.vmoptions";
    AQUA_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/aqua.vmoptions";
    RUSTROVER_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/rustrover.vmoptions";
    GATEWAY_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/gateway.vmoptions";
    JETBRAINS_CLIENT_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/jetbrains_client.vmoptions";
    JETBRAINSCLIENT_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/jetbrainsclient.vmoptions";
    STUDIO_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/studio.vmoptions";
    DEVECOSTUDIO_VM_OPTIONS = "$HOME/Documents/jetbra/vmoptions/devecostudio.vmoptions";
    # env for fonts
    XDG_DATA_HOME = "$HOME/nixos-config";

  };

  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # enable the tailscale service
  services.tailscale.enable = true;

    # 启用docker虚拟化
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    trustedInterfaces = ["wlp4s0" "virbr0"];
  };

  # Virt-manager 虚拟机
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["rxda"];
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };
  virtualisation.spiceUSBRedirection.enable = true;
 
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # DO NOT CHANGE!!!
  system.stateVersion = "24.11"; # Did you read the comment?

}
