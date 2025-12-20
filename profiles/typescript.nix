{
  mkProfile,
  nodejs_20,
  pnpm_9,
  unstable,
  yarn-berry,
}:

mkProfile {
  name = "typescript";
  paths = [
    nodejs_20
    pnpm_9
    unstable.typescript-language-server
    yarn-berry
  ];
}
