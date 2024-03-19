{
  mkProfile,
  tcpdump,
  inetutils,
  curl,
}:

mkProfile {
  name = "web";
  paths = [
    tcpdump
    inetutils
    curl
  ];
}
