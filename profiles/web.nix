{
  mkProfile,
  tcpdump,
  inetutils,
  curl,
  ngrok,
  mitmproxy,
  websploit,
}:

mkProfile {
  name = "web";
  paths = [
    tcpdump
    curl
    ngrok
    mitmproxy
    websploit
  ];
}
