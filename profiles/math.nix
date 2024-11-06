{
  mkProfile,
  matlab,
  libqalculate,
  gnuplot,
}:

mkProfile {
  name = "math";
  paths = [
    matlab
    libqalculate
    gnuplot
  ];
}
