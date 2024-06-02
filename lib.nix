{ self, snowcicles, ... }@inputs:
let
  lib = inputs.nixpkgs.lib;
in
{
  mkNixOS = snowcicles.lib.mkNixOSes (all: name: settings: {
    hyprland = false;
    modules = [
      ./hosts/${name}
    ];
    overlays = [
      self.overlays.default
    ]
      ++ lib.optional (settings.hyprland) (_: _: inputs.hyprland.packages.${settings.system});
  });

  mkHm = snowcicles.lib.mkHmManagers {
    defaults = all: name: settings: {
      hyprland = false;
      modules = [
        "${self}/home/${name}@${settings.hostname}"
      ];
      overlays = [
        self.overlays.default
      ]
        ++ lib.optional (settings.hyprland) (_: _: inputs.hyprland.packages.${settings.system});
    };
    hosts.clevo = "x86_64-linux";
  };
}
