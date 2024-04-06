{
  mkProfile,
  openvpn,
  wireguard-tools,
  boringtun,
}:

mkProfile {
  name = "vpn";
  paths = [
    openvpn
    wireguard-tools
    boringtun
  ];
}
