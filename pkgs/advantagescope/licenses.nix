{
  buildNpmPackage,
  src,
  pname,
  version,
  nodejs,
  npmDepsHash,
  cacert,
  patches,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = pname + "-licenses";
  inherit
    version
    src
    npmDepsHash
    patches
    ;

  makeCacheWritable = true;
  npmFlags = [ "--ignore-scripts" ];

  buildPhase = ''
    export NODE_EXTRA_CA_CERTS="${cacert}/etc/ssl/certs/ca-bundle.crt"
    node getLicenses.mjs
  '';

  installPhase = ''
    mkdir out
    mv ./src/licenses.json ./out
    cp -r ./out $out
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-P/ntPmTFm0LLNnAWGyNmRWin3n1yz8D8QZgnLPon1xk=";

  buildInputs = [ nodejs ];
})
