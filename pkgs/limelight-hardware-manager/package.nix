{
  lib,
  frc-nix-maintainers,
  stdenv,
  appimageTools,
  fetchurl,
  unzip,
}:
let
  hashes = {
    "x86_64-linux" = "sha256-PzIXk5jC2p2pZ6DUF4vJSF2WNToO6/ghrQdi/d4benY=";
    "aarch64-linux" = "sha256-moK4NZP21TCEfS/T7P2QdC6WAIcP1lt0aAqP0WxTmCA=";
  };
in
appimageTools.wrapType2 (finalAttrs: {
  pname = "limelight-hardware-manager";
  version = "2.0.12";

  src =
    let
      system = stdenv.hostPlatform.system;
      fileName = "LimelightHardwareManager-${lib.removeSuffix "-linux" system}_${
        lib.strings.replaceString "." "_" finalAttrs.version
      }.AppImage";
    in
    fetchurl {
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

  appimageContents = appimageTools.extract { inherit (finalAttrs) pname version src; };

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.appimageContents}/limelight-hardware-manager.png $out/share/pixmaps/${finalAttrs.pname}.png

    install -Dm444 ${finalAttrs.appimageContents}/limelight-hardware-manager.desktop $out/share/applications/${finalAttrs.pname}.desktop

    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace-fail 'Exec=/usr/bin/limelight-hardware-manager' 'Exec=${finalAttrs.pname}'
  '';

  extraPkgs = pkgs: [ pkgs.icu ];

  meta = {
    description = "Hardware management utility for Limelight devices";
    homepage = "https://docs.limelightvision.io";
    license = lib.licenses.unfree;
    maintainers = with frc-nix-maintainers; [ blaze-developer ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
