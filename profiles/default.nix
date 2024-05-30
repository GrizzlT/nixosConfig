{ ... }@inputs:
(inputs.snowcicles.lib.mkProfiles {
  defs = {
    c = import ./c.nix;
    deploy = import ./deploy.nix;
    python = import ./python.nix;
    web = import ./web.nix;
    pwn = import ./pwn.nix;
    crypto = import ./crypto.nix;
    forensics = import ./forensics.nix;
    misc = import ./misc.nix;
    audio = import ./audio.nix;
    hardware = import ./hardware.nix;
    typescript = import ./typescript.nix;
    typst-profile = import ./typst.nix;
    vpn = import ./vpn.nix;
    games = import ./games.nix;
  };
  basePathEnvDefault = "GRIZZ_PROFILES";
}) // {
  overlays = [
    inputs.snowcicles.inputs.agenix.overlays.default
    (import ./overlay.nix)
  ];
}
