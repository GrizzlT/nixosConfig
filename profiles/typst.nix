{
  mkProfile,
  typst,
  typstfmt,
  typst-lsp,
  typst-live,
  poppler_utils,
  ghostscript_headless,
}:

mkProfile {
  name = "typst";
  paths = [
    typst
    typstfmt
    typst-lsp
    typst-live
    poppler_utils
    ghostscript_headless
  ];
}
