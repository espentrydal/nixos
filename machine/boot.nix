{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  #boot.cleanTmpDir = true;
  #boot.tmpOnTmpfs = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-f6329525-fe75-4e9c-bc99-d60c7f587217".device = "/dev/disk/by-uuid/f6329525-fe75-4e9c-bc99-d60c7f587217";
  boot.initrd.luks.devices."luks-f6329525-fe75-4e9c-bc99-d60c7f587217".keyFile = "/crypto_keyfile.bin";

}
