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

  fileName = "LimelightHardwareManager-${lib.removeSuffix "-linux" system}_${lib.strings.replaceString "." "_" version}.AppImage";

  src = fetchurl {
    url = "https://downloads.limelightvision.io/software/${fileName}.zip";
    hash = hashes.${system};

    downloadToTemp = true;
    recursiveHash = true;
    nativeBuildInputs = [ unzip ];
    postFetch = ''
      unzip $downloadedFile
      install -Dm755 *.AppImage $out
    '';
  };

  hashes = {
    "x86_64-linux" = "sha256-PzIXk5jC2p2pZ6DUF4vJSF2WNToO6/ghrQdi/d4benY=";
    "aarch64-linux" = "sha256-moK4NZP21TCEfS/T7P2QdC6WAIcP1lt0aAqP0WxTmCA=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/limelight-hardware-manager.png $out/share/pixmaps/${pname}.png

    install -Dm444 ${appimageContents}/limelight-hardware-manager.desktop $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=/usr/bin/limelight-hardware-manager' 'Exec=${pname}'
  '';

  extraPkgs = pkgs: [ pkgs.icu ];

  meta = {
    description = "Hardware management utility for Limelight devices";
    homepage = "https://docs.limelightvision.io";
    license = lib.licenses.unfree;
    maintainers = with frc-nix-maintainers; [ blaze-developer ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}