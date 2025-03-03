{
  mkProfile,
  matlab,
  libqalculate,
  gnuplot,
  octave,
}:

mkProfile {
  name = "math";
  paths = [
    matlab
    libqalculate
    gnuplot
    (octave.withPackages (opkgs: [ opkgs.communications ]))
  ];
}
