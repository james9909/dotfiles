{ ... }:
let
  audio = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;
  };
in
{
  flake.modules.nixos.base.imports = [ audio ];
}
