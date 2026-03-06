{
  mkProfile,
  netcat-openbsd,
  socat,
  cutter,
  gdb,
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
  pwndbg,
  pwndbg-lldb,
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
    gef
    patchelf
    ltrace
    ghidra
    radare2
    iaito
    rizin

    pwndbg
    pwndbg-lldb

    ropgadget
    rp

    nmap
  ];
}
