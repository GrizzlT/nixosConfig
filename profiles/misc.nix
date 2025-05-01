{
  mkProfile,
  pv,
  qrencode,
  simplex-chat-desktop,
  erlang,
  ungoogled-chromium,
  tomb,
  ethtool,
  tigervnc,
  pandoc,
  texliveSmall,
  binwalk,
  sqlitebrowser,
  sqlite,
  imagemagick,
  uv,
  graphviz,
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
    binwalk

    tigervnc
    pandoc
    texliveSmall
    sqlitebrowser
    sqlite

    graphviz

    uv
    imagemagick
  ];
}
