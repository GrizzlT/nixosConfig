{
  mkProfile,
  clang-tools,
}:

mkProfile {
  name = "c";
  paths = [
    clang-tools
  ];
}
