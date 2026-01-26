{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    # TODO: add settings
  };

  home.packages = with pkgs; [
    (firefox.override { pkcs11Modules = [ pkgs.eid-mw ]; })
    (brave.override {
      commandLineArgs = [
        "--password-store=basic"
      ];
    })
  ];

  home.file.".mozilla/native-messaging-hosts/be.bosa.beidconnect.json".source = "${pkgs.beidconnect}/lib/mozilla/native-messaging-hosts/be.bosa.beidconnect.json";
  home.file.".mozilla/native-messaging-hosts/eu.webeid.json".source = "${pkgs.web-eid-app}/lib/mozilla/native-messaging-hosts/eu.webeid.json";

  home.file.".config/pkcs11/modules/beid.conf".text = ''
    module = ${pkgs.eid-mw}/lib/libbeidpkcs11.so
  '';

}
