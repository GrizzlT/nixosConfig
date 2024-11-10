{
  mkProfile,
  unstable,
  typstfmt,
  tinymist,
  typst-live,
  poppler_utils,
  ghostscript_headless,
  sioyek,
}:

mkProfile {
  name = "typst";
  paths = [
    unstable.typst
    typstfmt
    tinymist
    typst-live
    poppler_utils
    ghostscript_headless
    sioyek
  ];
}
