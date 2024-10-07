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
  mitmproxy,
  sslsplit,
  tcpreplay,

  fetchFromGitHub,
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

    mitmproxy
    (sslsplit.overrideAttrs (final: prev: {
      version = "8fb93453";
      src = fetchFromGitHub {
        owner = "droe";
        repo = prev.pname;
        rev = "8fb934536b692a39e2656beddecac91444cb7708";
        hash = "sha256-JLHFmfPGP9l3KhhLHEd6aseoS84t6w96SZbiS4jSmH8=";
      };
      patches = [];
    }))
    tcpreplay
  ];
}
