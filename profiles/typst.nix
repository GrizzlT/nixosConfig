{
  mkProfile,
  typst,
  typstfmt,
  typst-lsp,
  typst-live,
}:

mkProfile {
  name = "typst";
  paths = [
    typst
    typstfmt
    typst-lsp
    typst-live
  ];
}
