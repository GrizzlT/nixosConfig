{
  mkProfile,
  unstable,
  typstyle,
  typst-live,
  poppler-utils,
  ghostscript_headless,
  sioyek,
  harper,
}:

mkProfile {
  name = "typst";
  paths = [
    unstable.typst
    unstable.tinymist
    typstyle
    typst-live
    poppler-utils
    ghostscript_headless
    sioyek

    harper
  ];
}
