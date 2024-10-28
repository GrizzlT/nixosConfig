{
  mkProfile,
  unstable,
  typstfmt,
  typst-lsp,
  typst-live,
  poppler_utils,
  ghostscript_headless,
}:

mkProfile {
  name = "typst";
  paths = [
    unstable.typst
    typstfmt
    typst-lsp
    typst-live
    poppler_utils
    ghostscript_headless
  ];
}
