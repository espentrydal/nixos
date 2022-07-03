{
  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";

  #boot.cleanTmpDir = true;
  #boot.tmpOnTmpfs = true;

  boot.loader = {
     efi = {
       canTouchEfiVariables = true;
       efiSysMountPoint = "/boot/efi";
     };
     grub = {
       default = "saved";
       devices = [ "nodev" ];
       efiSupport = true;
       enable = true;
       extraEntries = ''
         menuentry "Windows" {
	  insmod part_gpt
	  insmod fat
	  insmod search_fs_uuid
	  insmod chain
	  search --fs-uuid --set=root 72F8-2745
	  chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      version = 2;
    };
  };

}
