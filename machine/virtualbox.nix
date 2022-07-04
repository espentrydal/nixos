{
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Virtualisation
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.x11 = true;
  boot.initrd.checkJournalingFS = false;
  /* fileSystems."/virtualboxshare" = {
    fsType = "vboxsf";
    device = " ";
    options = [ "rw" "nofail" ];
  }; */
}