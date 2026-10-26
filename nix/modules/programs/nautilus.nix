{
  flake.modules.nixos.nautilus =
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
      nautilus
      ffmpegthumbnailer
    ];
  };
}
