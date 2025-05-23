{
  mkProfile,
  mindustry-wayland,
  kdePackages,
}:

mkProfile {
  name = "games";
  paths = [
    mindustry-wayland

    kdePackages.kwallet
  ];
}
