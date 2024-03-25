{
  mkProfile,
  openvpn,
}:

mkProfile {
  name = "vpn";
  paths = [
    openvpn
  ];
}
