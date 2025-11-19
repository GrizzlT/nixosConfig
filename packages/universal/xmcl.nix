{ stdenv, nodejs, pnpm_9, lib, fetchFromGitHub }:

let
  version = "0.52.7";

  src = fetchFromGitHub {
    owner = "Voxelum";
    repo = "x-minecraft-launcher";
    rev = "v${version}";
    hash = "sha256-mFBAZ7dVy4ivBRGJA9EZNobST1iIVgnudKPyvAfb/Ec=";
  };

in stdenv.mkDerivation (finalAttrs: {
  pname = "xmcl";
  inherit version src;

  nativeBuildInputs = [
    nodejs
    pnpm_9
    pnpm_9.configHook
  ];

  # Makes PNPM use the precomputed store
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-BniyiGOs0oQPLhApJ9xMAV/+rHKE1bDVBuLOkv2/158=";
  };

  PNPM_DEPS = finalAttrs.pnpmDeps;

  # PNPM requires HOME for cache paths, but all deps come from PNPM_DEPS
  buildPhase = ''
    # export HOME=$PWD
    # export NODE_ENV=production
    #
    # echo "Installing dependencies offline..."
    # pnpm install --offline --frozen-lockfile
    #
    echo "Building xmcl-keystone-ui..."
    pnpm run --prefix xmcl-keystone-ui build

    echo "Building xmcl-electron-app..."
    pnpm run --prefix xmcl-electron-app build
  '';

  installPhase = ''
    mkdir -p $out
    ls -l
    cp -r xmcl-keystone-ui/dist $out/keystone-ui
    cp -r xmcl-electron-app/dist $out/electron-app
  '';
})

