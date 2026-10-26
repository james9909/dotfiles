{
  flake.modules.nixos.imv = 
  { lib, pkgs, ... }:
  let
    imageTypes = [
      "image/bmp" "image/gif" "image/heic" "image/jpeg" "image/jpg"
      "image/png" "image/tiff" "image/webp" "image/x-bmp"
    ];
  in
  {
    environment.systemPackages = [ pkgs.imv ];
    xdg.mime.defaultApplications = lib.genAttrs imageTypes (_: "imv.desktop");
  };
}
