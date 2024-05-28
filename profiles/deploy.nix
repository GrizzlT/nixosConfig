{
  mkProfile,
  deploy-rs,
  agenix,
  lz4,
}:

mkProfile {
  name = "deploy";
  paths = [
    deploy-rs
    agenix
    lz4
  ];
}
