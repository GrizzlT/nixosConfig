{
  mkProfile,
  matlab,
  libqalculate,
  gnuplot,
  octave,
  numbat,
}:

mkProfile {
  name = "math";
  paths = [
    matlab
    libqalculate
    numbat
    gnuplot
    (octave.withPackages (opkgs: [ opkgs.communications ]))
  ];
}
