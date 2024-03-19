{
  mkProfile,
  nodejs_20,
  nodePackages,
}:

mkProfile {
  name = "typescript";
  paths = [
    nodejs_20
    nodePackages.typescript-language-server
  ];
}
