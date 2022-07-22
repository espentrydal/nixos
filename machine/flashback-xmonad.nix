{ pkgs, ... }: {

  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.desktopManager.gnome.flashback.customSessions = [
    {
      wmName = "xmonad";
      wmLabel = "XMonad";
      wmCommand = "${pkgs.haskellPackages.xmonad}/bin/xmonad";
      enableGnomePanel = false;
    }
  ];
}
