{
  mkProfile,
  netcat-openbsd,
  socat,
  cutter,
  gdb,
  pwndbg,
  patchelf,
  ltrace,
  ghidra,
  radare2,
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
    patchelf
    ltrace
    ghidra
    radare2
    rizin

    ropgadget
    rp

    nmap
  ];
}
