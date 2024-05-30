{ self, snowcicles, ... }@inputs:
let
  lib = inputs.nixpkgs.lib;
in
{
  mkNixOS = snowcicles.lib.mkNixOSes (all: name: {
    modules = [
      ./hosts/${name}
    ];
    overlays = [
      self.overlays.default
    ]
      ++ lib.optional (all.${name}.hyprland or false) (_: _: inputs.hyprland.packages.${all.${name}.system or "x86_64-linux"});
  });

  mkHm = snowcicles.lib.mkHmManagers {
    defaults = all: name: host: {
      modules = [
        "${self}/home/${name}@${host.name}"
      ];
      overlays = [
        self.overlays.default
      ]
        ++ lib.optional (all.${name}.hyprland or false) (_: _: inputs.hyprland.packages.${host.value});
    };
    hosts.clevo = "x86_64-linux";
  };
}
