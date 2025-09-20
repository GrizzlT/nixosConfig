{ ... }@inputs:
(inputs.snowcicles.lib.mkProfiles {
  defs = {
    audio = import ./audio.nix;
    c = import ./c.nix;
    crypto = import ./crypto.nix;
    deploy = import ./deploy.nix;
    forensics = import ./forensics.nix;
    games = import ./games.nix;
    hardware = import ./hardware.nix;
    math = import ./math.nix;
    misc = import ./misc.nix;
    pwn = import ./pwn.nix;
    python = import ./python.nix;
    typescript = import ./typescript.nix;
    typst-profile = import ./typst.nix;
    vpn = import ./vpn.nix;
    web = import ./web.nix;
    haskell = import ./haskell.nix;
  };
  basePathEnvDefault = "GRIZZ_PROFILES";
}) // {
  overlays = [
    inputs.snowcicles.inputs.agenix.overlays.default
    inputs.nix-matlab.overlay
    (import ./overlay.nix)
  ];
}
