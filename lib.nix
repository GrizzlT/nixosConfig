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
    overlays = lib.optional (settings.hyprland) inputs.hyprland.overlays.default
      ++ [
        self.overlays.default
      ];
  });

  mkHm = snowcicles.lib.mkHmManagers {
    defaults = all: name: settings: {
      hyprland = false;
      spicetify = false;
      flakeDir = toString self;
      modules = [
        "${self}/home/${name}@${settings.hostname}"
      ] ++ lib.optional (settings.spicetify) inputs.spicetify.homeManagerModules.default;
      overlays = lib.optional (settings.hyprland) inputs.hyprland.overlays.default
        ++ [
          self.overlays.default
        ];

      spicetifyPkgs = inputs.spicetify.legacyPackages.${settings.system};
    };
    hosts.clevo = "x86_64-linux";
  };
}
