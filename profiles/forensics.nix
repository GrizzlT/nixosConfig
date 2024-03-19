{
  mkProfile,
  file,
  wireshark,
  bzip2,
  sleuthkit,
  testdisk,
  openjdk19,
  perl,
  hashcat,
  john,
}:

mkProfile {
  name = "forensics";
  paths = [
    file
    wireshark
    bzip2
    sleuthkit
    testdisk
    openjdk19
    perl

    hashcat
    john
  ];
}
