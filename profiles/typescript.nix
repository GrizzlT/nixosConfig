{
  mkProfile,
  nodejs_20,
  unstable,
  yarn-berry,
}:

mkProfile {
  name = "typescript";
  paths = [
    nodejs_20
    unstable.typescript-language-server
    yarn-berry
  ];
}
