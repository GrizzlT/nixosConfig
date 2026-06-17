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
  texliveFull,
  binwalk,
  sqlitebrowser,
  sqlite,
  csvlens,
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

  ast-grep,

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

  vscodium,
  nrf-command-line-tools,
  nrfconnect,
  nrf5-sdk,
  nrfutil,
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
    texliveFull
    sqlitebrowser
    sqlite
    csvlens

    graphviz

    ast-grep

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

    vscodium
    nrf-command-line-tools
    nrfconnect
    nrf5-sdk
  ];
}
