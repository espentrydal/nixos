{
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Virtualisation
  virtualisation.vmware.guest.enable = true;
  boot.initrd.checkJournalingFS = false;
}
