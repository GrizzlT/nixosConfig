{
  mkProfile,
  matlab,
  libqalculate,
}:

mkProfile {
  name = "math";
  paths = [
    matlab
    libqalculate
  ];
}
