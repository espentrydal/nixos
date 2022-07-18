{ config, pkgs, ... }: {

  services.xserver.enable = true;
  # FIXME this works for WM and chrome, but does not seem to work for xterm and
  # urxvt. Thus I'm currently still using .Xresources
  services.xserver.dpi = 144;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "no";
    xkbVariant = "";
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = false;
  services.xserver.displayManager.autoLogin.user = "espen";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # THus, I'm manually sourcing ~/.profile before starting the display manager
  #services.xserver.displayManager.sessionCommands = "source $HOME/.profile";

  qt5.enable = true;
  qt5.platformTheme = "gtk2";
  qt5.style = "gtk2";

}
