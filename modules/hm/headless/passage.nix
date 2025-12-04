{ pkgs, ... }:
{
  home.sessionVariables = {
    PASSAGE_DIR = "$HOME/DATA/.passage/store";
    PASSAGE_IDENTITIES_FILE = "$HOME/DATA/.passage/identities";
    PASSAGE_RECIPIENTS_FILE = "$HOME/DATA/.passage/store/.age-recipients";
    PASSWORD_STORE_CLIP_TIME = 20;
    PASSWORD_STORE_GENERATED_LENGTH = 20;
  };

  home.packages = with pkgs; [
    passage
    age
    age-plugin-yubikey
    age-plugin-fido2-hmac
    paperage
  ];
}
