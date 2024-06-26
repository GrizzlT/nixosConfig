{
  mkProfile,
  file,
  bzip2,
  sleuthkit,
  testdisk,
  openjdk19,
  perl,
  hashcat,
  john,
  aircrack-ng,
}:

mkProfile {
  name = "forensics";
  paths = [
    file
    bzip2
    sleuthkit
    testdisk
    openjdk19
    perl

    hashcat
    john
    aircrack-ng
  ];
}
