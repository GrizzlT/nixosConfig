{
  keyboardConfig = ./grizz-keyboard.nix;
  nixConfig = ./nix-settings.nix;

  locale = ./locale.nix;
  minimalPackages = ./minimalPackages.nix;
  pipewire = ./pipewire.nix;
  printing = ./printing.nix;
  stylix = ./stylix.nix;
  tailscale = ./tailscale.nix;
  virtualisation = ./virtualisation.nix;
  xorg = ./xorg.nix;
}
