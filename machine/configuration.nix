# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    ref = "release-22.05";
  };
  nixos-hardware = builtins.fetchGit {
    url = "https://github.com/espentrydal/nixos-hardware.git";
    ref = "master";
  };
in
{
  imports =
    [
      (import "${nixos-hardware}/lenovo/thinkpad/x1-extreme/gen1")
      /etc/nixos/hardware-configuration.nix
      ./boot.nix
      ./home-users.nix
      ./x11.nix
      #./stumpwm.nix
      #./flashback-xmonad.nix
      (import "${home-manager}/nixos")
    ];

  nix = {
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      # "nixos-config=/path/to/machines/${config.networking.hostName}/configuration.nix"
      "nixos-config=/home/espen/34_01-linux-home/nixos/machine/configuration.nix" ];
    package = pkgs.nixFlakes;
    extraOptions = ''
                 experimental-features = nix-command flakes

                 tarball-ttl = 0
                 narinfo-cache-negative-ttl = 0
                 narinfo-cache-positive-ttl = 0
                 '';
    gc.automatic = true;
    gc.dates = "weekly";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.tarball-ttl = 0;
  nixpkgs.config.tarballTtl = 0;

  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-22.05/";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    clojure
    emacs
    feh
    firefox
    fzf
    git
    git-credential-gopass
    gparted
    gnupg
    gopass
    htop
    mosh
    neovim
    pciutils
    ripgrep
    rpi-imager
    sqlite
    tailscale
    tree
    sbcl lispPackages.clwrapper lispPackages.swank cmake ruby
    vivaldi
    wget
    zotero
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  services.emacs.enable = true;
  #services.emacs.package = import /home/espen/.emacs.d { pkgs = pkgs; };

  # services.emacs.package = pkgs.emacsGitNativeComp;
  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #   }))
  # ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    # liberation_ttf
    fira-code
    # fira-code-symbols
    # mplus-outline-fonts
    # dina-font
    # proggyfonts
    anonymousPro
    # FIXME this has otf fonts
    source-code-pro
    # FIXME these have ttc fonts, and not even copied to /share/X11-fonts.
    wqy_microhei
    wqy_zenhei
  ];

  # /run/current-system/sw/share/X11-fonts
  # fonts.fontDir.enable = true;
  fonts.enableDefaultFonts = true;

  networking.hostName = "thinkpad-nixos"; # Define your hostname.
  services.acpid.enable = true;
  powerManagement.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.wireless.networks = {
    Get-D445A3 = {
      pskRaw="665af6c0e84f5c29d57e3abcb57ee62002392fb38546e16bc78c2a51d5fcf4b4";
    };
    Markblomst = {
      pskRaw="8b3583b1fd3dbc24776d65a204f32bfb90a699ddeb0677bb2ea5f4456266942c";
    };
  };

  # services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # enable the tailscale daemon; this will do a variety of tasks:
  # 1. create the TUN network device
  # 2. setup some IP routes to route through the TUN
  services.tailscale = { enable = true; };
  networking.firewall.allowedUDPPorts = [ 41641 ];
  # Disable SSH access through the firewall
  services.openssh.openFirewall = false;
  networking.firewall.checkReversePath = "loose";

  # Set your time zone.
  time.timeZone = "Europe/Oslo";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  # Configure console keymap
  console.keyMap = "no";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    #media-session.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';

  services.udev.extraRules = '' ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect $devnode /media" '';

  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "espen" ];
  #virtualisation.docker.enable = true;
  #virtualisation.docker.enableNvidia = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
