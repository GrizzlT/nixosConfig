{ self, snowcicles, ... }@inputs:
let
  lib = inputs.nixpkgs.lib;
in
{
  mkNixOS = snowcicles.lib.mkNixOSes (all: name: settings: {
    hyprland = false;
    flakeDir = toString self;
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
      spicetify = false;
      flakeDir = toString self;
      modules = [
        "${self}/home/${name}@${settings.hostname}"
      ] ++ lib.optional (settings.spicetify) inputs.spicetify.homeManagerModules.default;
      overlays = [
        self.overlays.default
      ]
        ++ lib.optional (settings.hyprland) (_: _: inputs.hyprland.packages.${settings.system});

      spicetifyPkgs = inputs.spicetify.legacyPackages.${settings.system};
    };
    hosts.clevo = "x86_64-linux";
  };
}
