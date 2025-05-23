{
  mkProfile,
  unstable,
  typstfmt,
  typst-live,
  poppler_utils,
  ghostscript_headless,
  sioyek,
  harper,
}:

mkProfile {
  name = "typst";
  paths = [
    unstable.typst
    unstable.tinymist
    typstfmt
    typst-live
    poppler_utils
    ghostscript_headless
    sioyek

    harper
  ];
}
