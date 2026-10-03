{ config, inputs, ... }:

{
  flake.modules.nixos."hosts/phoenix" = 
    { pkgs, ... }:
    {
      networking = {
        hostName = "phoenix";
	networkmanager.enable = true;
      };

      boot = {
        loader = {
	  systemd-boot.enable = true;
	  efi.canTouchEfiVariables = true;
	};
        initrd.luks.devices."luks-988e07fd-6922-4dc9-9716-232318806a8c".device = "/dev/disk/by-uuid/988e07fd-6922-4dc9-9716-232318806a8c";
      };

      time.timeZone = "America/Los_Angeles";

      i18n = {
        defaultLocale = "en_US.UTF-8";

        extraLocaleSettings = {
          LC_ADDRESS = "en_US.UTF-8";
          LC_IDENTIFICATION = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "en_US.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
        };
      };

      users.users."james" = {
        isNormalUser = true;
        description = "James Wang";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [];
      };

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [
        neovim
        hyprland
        kitty
        git
      ];

      system.stateVersion = "26.05"; # Did you read the comment?

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      programs.hyprland.enable = true;
      programs.firefox.enable = true;
    };

  flake.nixosConfigurations.phoenix = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos."hosts/phoenix"
    ];
  };
}
