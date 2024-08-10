{
  mkProfile,
  pv,
  qrencode,
  simplex-chat-desktop,
  erlang,
  ungoogled-chromium,
  tomb,
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
  ];
}
