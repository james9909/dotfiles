{ config, ... }:

{
  flake.modules.nixos."hosts/phoenix" = 
    { config, lib, modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot = {
        initrd = {
          availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
	  kernelModules = [];
          luks.devices."luks-3d32e6d6-ae1d-4c2a-893e-f795627eac4a".device = "/dev/disk/by-uuid/3d32e6d6-ae1d-4c2a-893e-f795627eac4a";
	};
	kernelModules = [ "kvm-amd" ];
	extraModulePackages = [];
      };

      fileSystems = {
        "/" = {
          device = "/dev/mapper/luks-3d32e6d6-ae1d-4c2a-893e-f795627eac4a";
          fsType = "ext4";
	};

	"/boot" = {
          device = "/dev/disk/by-uuid/986D-AC96";
          fsType = "vfat";
          options = [ "fmask=0077" "dmask=0077" ];
	};
      };

      swapDevices = [
        { device = "/dev/mapper/luks-988e07fd-6922-4dc9-9716-232318806a8c"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
