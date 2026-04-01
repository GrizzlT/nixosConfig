{
  mkProfile,
  audacity,
  gnuradio,
}:

mkProfile {
  name = "audio";
  paths = [
    audacity
    gnuradio
  ];
}
