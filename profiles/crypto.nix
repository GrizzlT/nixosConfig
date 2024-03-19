{
  mkProfile,
  sageWithDoc,
  openssl,
}:

mkProfile {
  name = "crypto";
  paths = [
    sageWithDoc
    openssl
  ];
}
