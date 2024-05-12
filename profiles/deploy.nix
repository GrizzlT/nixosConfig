{
  mkProfile,
  deploy-rs,
  agenix,
  lz4,
}:

mkProfile {
  name = "c";
  paths = [
    deploy-rs
    agenix
    lz4
  ];
}
