{ ... }:
{
  age.identityPaths = [ "/persist/var/lib/id_ed25519" ];

  age.secrets = {
    wpaPasswords.file = ../../secrets/wpa_passwords.age;
  };
}
