{
  mkProfile,
  mindustry-wayland,
}:

mkProfile {
  name = "games";
  paths = [
    mindustry-wayland
  ];
}
