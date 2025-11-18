{ stdenv, nodejs, pnpm_9, lib, fetchFromGitHub }:

let
  version = "0.52.7";

  src = fetchFromGitHub {
    owner = "Voxelum";
    repo = "x-minecraft-launcher";
    rev = "v${version}";
    hash = lib.fakeHash;
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit stdenv lib;
    name = "xmcl-deps";
    src = src;                                # <= origin of lockfile
    lockfile = "${src}/pnpm-lock.yaml";       # <= resolved relative to src
  };

in stdenv.mkDerivation {
  pname = "xmcl";
  inherit version src;

  nativeBuildInputs = [
    nodejs
    pnpm_9
    pnpm_9.configHook
  ];

  # Makes PNPM use the precomputed store
  inherit pnpmDeps;
  PNPM_DEPS = pnpmDeps;

  # PNPM requires HOME for cache paths, but all deps come from PNPM_DEPS
  buildPhase = ''
    export HOME=$PWD
    export NODE_ENV=production

    echo "Installing dependencies offline..."
    pnpm install --offline --frozen-lockfile

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
}

