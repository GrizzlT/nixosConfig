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
  hexyl,
  dumbpipe,
  sendme,

  wordlists,
  net-tools,

  bender,
  verilator,
  hyperfine,
  snakemake,
  pixi,
  libcgroup,

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
    hexyl

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

    bender
    verilator
    snakemake
    pixi

    wordlists
    net-tools

    hyperfine
    libcgroup
  ];
}
