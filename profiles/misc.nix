{
  mkProfile,
  pv,
  qrencode,
  simplex-chat-desktop,
  erlang,
  ungoogled-chromium,
  tomb,
  ethtool,
}:

mkProfile {
  name = "misc";
  paths = [
    pv
    qrencode
    simplex-chat-desktop
    erlang
    ungoogled-chromium

    tomb

    ethtool
  ];
}
