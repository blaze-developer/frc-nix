{
  lib,
  frc-nix-maintainers,
  stdenv,
  appimageTools,
  fetchurl,
  unzip,
  makeDesktopItem,
  copyDesktopItems
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

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;
  
  installPhase = ''
    install -Dm444 ${icon} "$out"/share/pixmaps/${pname}.svg
  '';

  extraPkgs = pkgs: [ pkgs.icu ];

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Limelight Hardware Manager";
      name = pname;
      exec = pname;
      icon = pname;
      comment = "Hardware management utility for Limelight devices";
      categories = [
        "Robotics"
        "System"
        "Utility"
      ];
      keywords = [
        "FRC"
        "FTC"
        "hardware"
        "limelight"
        "device"
        "manager"
      ];
    })
  ];

  meta = {
    description = "Hardware management utility for Limelight devices";
    homepage = "https://docs.limelightvision.io";
    license = lib.licenses.unfree;
    maintainers = with frc-nix-maintainers; [ blaze-developer ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}