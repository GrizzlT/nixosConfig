{
  mkProfile,
  mindustry-wayland,
  gdlauncher-carbon,
}:

mkProfile {
  name = "games";
  paths = [
    mindustry-wayland
    gdlauncher-carbon
  ];
}
