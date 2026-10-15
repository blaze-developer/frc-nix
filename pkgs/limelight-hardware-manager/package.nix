{
  lib,
  frc-nix-maintainers,
  appimageTools,
  fetchurl,
  unzip
}:
let
  pname = "limelight-hardware-manager";
  version = "2.0.12";

  imageName = "LimelightHardwareManager-x86_64_${lib.strings.replaceString "." "_" version}.AppImage";
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = "https://downloads.limelightvision.io/software/${imageName}.zip";
    hash = "sha256-PzIXk5jC2p2pZ6DUF4vJSF2WNToO6/ghrQdi/d4benY=";

    downloadToTemp = true;
    recursiveHash = true;
    nativeBuildInputs = [ unzip ];
    postFetch = ''
      unzip $downloadedFile
      install -Dm755 *.AppImage $out
    '';
  };

  extraPkgs = pkgs: [
    pkgs.icu
  ];

  meta = {
    description = "Limelight Hardware Manager is a utility tool used to discover, configure, and flash images onto the Limelight Systemcore and Limelight Smart Cameras.";
    homepage = "https://docs.limelightvision.io";
    license = lib.licenses.unfree;
    maintainers = with frc-nix-maintainers; [ blaze-developer ];
    platforms = [ "x86_64-linux" ];
  };
}