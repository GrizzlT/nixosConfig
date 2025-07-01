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
  unstable,
  graphviz,
  gv,
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

    unstable.saw-tools
    unstable.yosys
    gv

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
