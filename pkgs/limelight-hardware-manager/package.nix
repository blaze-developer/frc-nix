{
  lib,
  frc-nix-maintainers,
  stdenv,
  appimageTools,
  fetchurl,
  unzip
}:
let
  pname = "limelight-hardware-manager";
  version = "2.0.12";

  system = stdenv.hostPlatform.system;

  imageName = "LimelightHardwareManager-${lib.removeSuffix "-linux" system}_${lib.strings.replaceString "." "_" version}.AppImage";

  hashes = {
    "x86_64-linux" = "sha256-PzIXk5jC2p2pZ6DUF4vJSF2WNToO6/ghrQdi/d4benY=";
    "aarch64-linux" = "sha256-moK4NZP21TCEfS/T7P2QdC6WAIcP1lt0aAqP0WxTmCA=";
  };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = "https://downloads.limelightvision.io/software/${imageName}.zip";
    hash = hashes.${system};

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
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}