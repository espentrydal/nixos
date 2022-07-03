{ pkgs, ...}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.espen = {
    isNormalUser = true;
    home = "/home/espen";
    description = "Espen Trydal";
    extraGroups = [ "networkmanager" "wheel" ];
    uid = 1000;
  };

  # NOTE: This allows easy management of my system configuration, without
  # managing ~/.config/nixpkgs/config.nix, but it is not very convenient for
  # user to maintain packages, i.e. this file needs to be modified, and sudo
  # nixos-rebuild needs to be issued.
  #
  # These pkgs symlink to /etc/profiles/per-user/espen/lib
  #
  # The pkgs installed using nix-env goes into $HOME/.nix-profile/lib
  users.users.espen.packages = with pkgs; [
      sbcl lispPackages.clwrapper lispPackages.swank cmake ruby
      gnome3.gnome-tweaks
    ];

  home-manager.users.espen = { config, pkgs, ... }: {
    home.username = "espen";
    programs.git = {
      enable = true;
      userName = "Espen Trydal";
      userEmail = "espen@trydal.io";
      extraConfig = {
        credential.helper = "gopass";
      };
    };
    # docker-compose nvidia-docker
    home.packages = [ pkgs.python39 ];
    # programs.bash.enable = true;

  };
  
}
