{
  buildNpmPackage,
  src,
  pname,
  version,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = pname + "-docs";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/docs";
  npmDepsHash = "sha256-5PSdhBflI4wYsWQHGPmmga5vitZ/DqvNV11Kc6i3EdY=";

  buildPhase = ''
    npm run build-embed
  '';

  installPhase = ''
    cp -r ./build $out
  '';
})
