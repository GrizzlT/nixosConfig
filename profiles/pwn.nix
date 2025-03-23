{
  mkProfile,
  netcat-openbsd,
  socat,
  cutter,
  gdb,
  pwndbg,
  gef,
  patchelf,
  ltrace,
  ghidra,
  radare2,
  iaito,
  rizin,
  ropgadget,
  rp,
  nmap,
}:

mkProfile {
  name = "pwn";
  paths = [
    netcat-openbsd
    socat
    (cutter.withPlugins (p: [
      p.rz-ghidra
    ]))
    gdb
    pwndbg
    gef
    patchelf
    ltrace
    ghidra
    radare2
    iaito
    rizin

    ropgadget
    rp

    nmap
  ];
}
