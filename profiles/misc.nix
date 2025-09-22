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
  pngtools,
  exiftool,
  imagemagick,
  uv,
  unstable,
  graphviz,
  gv,
  dumbpipe,
  sendme,

  sigdigger,
  inspectrum,
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

    pngtools
    exiftool

    unstable.saw-tools
    unstable.yosys
    gv

    dumbpipe
    sendme

    tigervnc
    pandoc
    texliveSmall
    sqlitebrowser
    sqlite

    graphviz

    uv
    imagemagick

    sigdigger
    inspectrum
  ];
}
