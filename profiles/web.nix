{
  mkProfile,
  tcpdump,
  inetutils,
  curl,
  ngrok,
  mitmproxy,
  websploit,
  nodePackages
}:

mkProfile {
  name = "web";
  paths = [
    tcpdump
    inetutils
    curl
    ngrok
    mitmproxy
    websploit
    nodePackages.localtunnel
  ];
}
