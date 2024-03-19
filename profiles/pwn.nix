{
  mkProfile,
  netcat-openbsd,
  cutter,
  gdb,
  pwndbg,
  patchelf,
  ltrace,
  ghidra,
  ropgadget,
  rp,
  nmap,
}:

mkProfile {
  name = "pwn";
  paths = [
    netcat-openbsd
    (cutter.withPlugins (p: [
      p.rz-ghidra
    ]))
    gdb
    pwndbg
    patchelf
    ltrace
    ghidra

    ropgadget
    rp

    nmap
  ];
}
