{ ... }: {
  services.syncthing = {
    enable = true;
    user = "grizz";
    group = "users";
    configDir = "/home/grizz/DATA/.syncthing";
  };
}
