{
  flake.modules.nixos.noctalia-greeter = {
    services.displayManager.noctalia-greeter = {
      enable = true;
    };
  };
}
