{
  mkProfile,
  pv,
  qrencode,
  simplex-chat-desktop
}:

mkProfile {
  name = "misc";
  paths = [
    pv
    qrencode
    simplex-chat-desktop
  ];
}
